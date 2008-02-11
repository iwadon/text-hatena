require "text/hatena/auto_link/scheme"

module Text
  class Hatena
    class AutoLink
      class HatenaBookmark < Scheme
        @@pattern_keyword = /\[(b:(keyword|t):([^\]]+))\]/
        @@pattern_usertag = /\[(b:id:([A-Za-z][a-zA-Z0-9_\-]{2,14}):t:([^\]]+))\]/
        @@pattern_user = /\[?(b:id:([A-Za-z][a-zA-Z0-9_\-]{2,14})(?::(favorite|asin|\d{8}))?)\]?/

        def patterns
          [@@pattern_keyword, @@pattern_usertag, @@pattern_user]
        end

        def init
          super
          @domain = 'b.hatena.ne.jp'
        end

        def parse(text, opt = {})
          case text
          when @@pattern_keyword
            _parse_keyword(text)
          when @@pattern_usertag
            _parse_usertag(text)
          when @@pattern_user
            _parse_user(text)
          end
        end

        def _parse_keyword(text)
          return if @@pattern_keyword !~ text
          title, type, word = $1, $2, $3
          return sprintf('<a href="http://%s/%s/%s"%s>%s</a>',
                         @domain, type, html_encode(word),
                         @a_target_string, title)
        end

        def _parse_user(text)
          return if @@pattern_user !~ text
          title, name, page = $1, $2, $3 || ''
          return sprintf('<a href="http://%s/%s/%s"%s>%s</a>',
                         @domain, name, page,
                         @a_target_string, title)
        end

        def _parse_usertag(text)
          return if @@pattern_usertag !~ text
          title, name, tag = $1, $2, $3
          return sprintf('<a href="http://%s/%s/%s/"%s>%s</a>',
                         @domain, name, html_encode(tag),
                         @a_target_string, title)
        end
      end
    end
  end
end
