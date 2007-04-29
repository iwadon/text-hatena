require "text/hatena/auto_link/scheme"

module Text
  class Hatena
    class AutoLink
      class HatenaGraph < Scheme
        @@pattern_tag = /\[(graph:t:([^\]]+))\]/i
        @@pattern_image = /\[graph:id:([A-Za-z][a-zA-Z0-9_\-]{2,14}):(.+):image\]/i
        @@pattern_simple = /\[graph:id:([A-Za-z][a-zA-Z0-9_\-]{2,14}):(.+)\]/i
        @@pattern_user = /\[?graph:id:([A-Za-z][a-zA-Z0-9_\-]{2,14})\]?/i

        def patterns
          [@@pattern_tag, @@pattern_image, @@pattern_simple, @@pattern_user]
        end

        def init
          super
          @domain = 'graph.hatena.ne.jp'
        end

        def parse(text, opt = {})
          case text
          when @@pattern_tag
            _parse_tag(text)
          when @@pattern_image
            _parse_image(text)
          when @@pattern_simple
            _parse_simple(text)
          when @@pattern_user
            _parse_user(text)
          end
        end

        def _parse_tag(text)
          return if @@pattern_tag !~ text
          name, tag = $1, $2
          return sprintf('<a href="http://%s/t/%s"%s>%s</a>',
                         @domain, html_encode(tag),
                         @a_target_string, name)
        end

        def _parse_image(text)
          return if @@pattern_image !~ text
          name, graphname = $1, $2
          engname = html_encode(graphname)
          return sprintf('<a href="http://%s/%s/%s/"%s><img src="http://%s/%s/graph?graphname=%s" class="hatena-graph-image" alt="%s" title="%s"></a>',
                         @domain, name, engname, @a_target_string,
                         @domain, name, engname,
                         escape_attr(graphname), escape_attr(graphname))
        end

        def _parse_simple(text)
          return if @@pattern_simple !~ text
          name, graphname = $1, $2
          return sprintf('<a href="http://%s/%s/%s/"%s>graph:id:%s:%s</a>',
                         @domain, name, html_encode(graphname),
                         @a_target_string, name, graphname)
        end

        def _parse_user(text)
          return if @@pattern_user !~ text
          name = $1
          return sprintf('<a href="http://%s/%s/"%s>graph:id:%s</a>',
                         @domain, name, @a_target_string, name)
        end
      end
    end
  end
end
