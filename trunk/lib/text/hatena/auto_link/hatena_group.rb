require "text/hatena/auto_link/scheme"

module Text
  class Hatena
    class AutoLink
      class HatenaGroup < Scheme
        @@pattern_group_archive = /\[?(g:([a-z][a-z0-9\-]{2,23}))(:id:([A-Za-z][a-zA-Z0-9_\-]{2,14}))(:(archive)(?::(\d{6}))?)\]?/i
        @@pattern_group_diary = /\[?(g:([a-z][a-z0-9\-]{2,23}))(:id:([A-Za-z][a-zA-Z0-9_\-]{2,14}))(\:(\d{8}))?(?:(\#|:)([a-zA-Z0-9_]+))?\]?/i
        @@pattern_group_keyword = /\[g:([a-z][a-z0-9\-]{2,23}):keyword:([^\]]+)\]/i
        @@pattern_group_bbs = /\[?(?:g:([a-z][a-z0-9\-]{2,23}):)?bbs:(\d+)(?::(\d+))?\]?/i

        def patterns
          [@@pattern_group_archive, @@pattern_group_diary, @@pattern_group_keyword, @@pattern_group_bbs]
        end

        def init
          super
          @domain = 'g.hatena.ne.jp'
        end

        def parse(text, opt = {})
          case text
          when @@pattern_group_archive
            return _parse_group_archive(text)
          when @@pattern_group_diary
            return _parse_group_diary(text)
          when @@pattern_group_keyword
            return _parse_group_keyword(text)
          when @@pattern_group_bbs
            return _parse_group_bbs(text)
          end
        end

        def _parse_group_archive(text)
          return if @@pattern_group_archive !~ text
          month = $7 ? "/#{$7}" : ''
          return sprintf('<a href="http://%s.%s/%s/%s%s">%s%s%s</a>',
                         $2,
                         @domain,
                         $4,
                         $6,
                         month,
                         $1,
                         $3,
                         $5
                         )
        end

        def _parse_group_diary(text)
          return if @@pattern_group_diary !~ text
          m1, m2, m3, m4, m5, m6, m7, m8 = $1, $2, $3 || '', $4 || '', $5 || '', $6 || '', $7, $8
          if m7
            date = m6 != '' ? "/#{m6}" : ''
            delim = m7 == ':' ? '/' : '#'
            return sprintf('<a href="http://%s.%s/%s%s%s%s">%s%s%s%s%s</a>',
                           m2, @domain, m4, date, delim, m8, m1, m3,
                           m5, m7, m8)
          else
            return sprintf('<a href="http://%s.%s/%s/%s">%s%s%s</a>',
                           m2, @domain, m4, m6, m1, m3, m5)
          end
        end

        def _parse_group_keyword(text)
          return if @@pattern_group_keyword !~ text
          gname, word = $1, $2
          enword = html_encode(word)
          return sprintf('<a class="okeyword" href="http://%s.%s/keyword/%s">g:%s:keyword:%s</a>',
                         gname,
                         @domain,
                         enword,
                         gname,
                         word)
        end

        def _parse_group_bbs(text)
          return if @@pattern_group_bbs !~ text
          gname, tid, aid = $1, $2, $3
          url = ''
          title = ''
          if gname
            url = "http://#{gname}." + @domain
            title = "g:#{gname}:"
          end
          url += "/bbs/#{tid}"
          title += "bbs:#{tid}"
          if aid
            url += "/#{aid}"
            title += ":#{aid}"
          end
          return %Q|<a href="#{url}">#{title}</a>|
        end
      end
    end
  end
end
