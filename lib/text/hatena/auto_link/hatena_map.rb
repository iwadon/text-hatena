require "text/hatena/auto_link/scheme"

module Text
  class Hatena
    class AutoLink
      class HatenaMap < Scheme
        @@pattern_tag = /\[(map:t:([^\]]+))\]/i
        @@pattern_map = /\[?(map:x(\-?[\d\.]+)y(\-?[\d\.]+))\]?/i
        @@pattern_search = /\[(map:([^\]]+))\]/i

        def patterns
          [@@pattern_tag, @@pattern_map, @@pattern_search]
        end

        def init
          super
          @domain = 'map.hatena.ne.jp'
        end

        def parse(text, opt = {})
          case text
          when @@pattern_tag
            _parse_tag(text)
          when @@pattern_map
            _parse_map(text)
          when @@pattern_search
            _parse_search(text)
          end
        end

        def _parse_tag(text)
          return unless @@pattern_tag =~ text
          name, tag = $1, $2
          return sprintf('<a href="http://%s/t/%s"%s>%s</a>',
                         @domain, html_encode(tag), @a_target_string, name)
        end

        def _parse_map(text)
          return unless @@pattern_map =~ text
          name, x, y = $1, $2, $3
          return sprintf('<a href="http://%s/?x=%s&y=%s&z=4"%s>%s</a>',
                         @domain, x, y,
                         @a_target_string, name)
        end

        def _parse_search(text)
          return unless @@pattern_search =~ text
          name, wd = $1, $2
          return sprintf('<a href="http://%s/?word=%s"%s>%s</a>',
                         @domain, html_encode(wd),
                         @a_target_string, name)
        end
      end
    end
  end
end
