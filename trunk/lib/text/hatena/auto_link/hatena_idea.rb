require "text/hatena/auto_link/scheme"

module Text
  class Hatena
    class AutoLink
      class HatenaIdea < Scheme
        @@pattern_user = /\[?(i:id:([A-Za-z][a-zA-Z0-9_\-]{2,14}))\]?/i
        @@pattern_tag = /\[(i:t:([^\]]+))\]/i
        @@pattern_idea = /\[?(idea:(\d+))\]?/i

        def patterns
          [@@pattern_user, @@pattern_idea, @@pattern_tag]
        end

        def init
          super
          @domain = 'i.hatena.ne.jp'
        end

        def parse(text, opt = {})
          case text
          when @@pattern_user
            _parse_user(text)
          when @@pattern_idea
            _parse_idea(text)
          when @@pattern_tag
            _parse_tag(text)
          end
        end

        def _parse_idea(text)
          return if @@pattern_idea !~ text
          title, iid = $1, $2
          return sprintf('<a href="http://%s/idea/%s"%s>%s</a>',
                         @domain, iid, @a_target_string, title)
        end

        def _parse_user(text)
          return if @@pattern_user !~ text
          title, name = $1, $2
          return sprintf('<a href="http://%s/%s/"%s>%s</a>',
                         @domain, name, @a_target_string, title)
        end

        def _parse_tag(text)
          return if @@pattern_tag !~ text
          title, word = $1, $2
          return sprintf('<a href="http://%s/t/%s"%s>%s</a>',
                         @domain, html_encode(word),
                         @a_target_string, title)
        end
      end
    end
  end
end
