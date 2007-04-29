require "text/hatena/auto_link/scheme"

module Text
  class Hatena
    class AutoLink
      class HatenaDiary < Scheme
        @@pattern_about = /\[?(d:id:([A-Za-z][a-zA-Z0-9_\-]{2,14}):(about|keywordlist))\]?/i
        @@pattern_archive = /\[?(d:id:([A-Za-z][a-zA-Z0-9_\-]{2,14}):(archive)(?::(\d{6}))?)\]?/i
        @@pattern_diary = /\[?(d:id:([A-Za-z][a-zA-Z0-9_\-]{2,14}))(\:(\d{8}))?(?:(\#|:)([a-zA-Z0-9_]+))?\]?/i
        @@pattern_keyword = /\[d:keyword:(.+?)\]/i

        def patterns
          [@@pattern_about, @@pattern_archive, @@pattern_diary, @@pattern_keyword]
        end

        def init
          super
          @domain = 'd.hatena.ne.jp'
        end

        def parse(text, opt = {})
          case text
          when @@pattern_about
            _parse_about(text)
          when @@pattern_archive
            _parse_archive(text)
          when @@pattern_diary
            _parse_diary(text)
          when @@pattern_keyword
            _parse_keyword(text)
          end
        end

        def _parse_diary(text)
          return if @@pattern_diary !~ text
          m1, m2, m3, m4, m5, m6 = $1, $2, $3 || '', $4 || '', $5 || '', $6 || ''
          unless m5.empty?
            delim = m5 == ':' ? '/' : '#'
            return sprintf('<a href="http://%s/%s/%s%s%s"%s>%s%s%s%s</a>',
                           @domain, m2, m4, delim,
                           m6, @a_target_string, m1, m3, m5, m6)
          else
            return sprintf('<a href="http://%s/%s/%s"%s>%s%s</a>',
                           @domain, m2, m4, @a_target_string, m1, m3)
          end
        end

        def _parse_about(text)
          return if @@pattern_about !~ text
          content, username, page = $1, $2, $3 || ''
          return sprintf('<a href="http://%s/%s/%s"%s>%s</a>',
                         @domain, username, page, @a_target_string,
                         content)
        end

        def _parse_archive(text)
          return if @@pattern_archive !~ text
          content, username, page, month = $1, $2, $3 || '', $4 || ''
          month = "/#{month}" unless month.empty?
          return sprintf('<a href="http://%s/%s/%s%s"%s>%s</a>',
                         @domain, username, page, month,
                         @a_target_string, content)
        end

        def _parse_keyword(text)
          return if @@pattern_keyword !~ text
          word = $1
          enword = html_encode(word.toeuc)
          enword.gsub!(/%2f/, '/')
          return sprintf('<a href="http://%s/keyword/%s"%s>d:keyword:%s</a>',
                         @domain, enword, @a_target_string,
                         word)
        end
      end
    end
  end
end
