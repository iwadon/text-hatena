require "text/hatena/auto_link/scheme"

module Text
  class Hatena
    class AutoLink
      class HatenaQuestion < Scheme
        @@pattern_user = /\[?(q:id:([A-Za-z][a-zA-Z0-9_\-]{2,14}))\]?/i
        @@pattern_question = /\[?(question:(\d+))\]?/i

        def patterns
          [@@pattern_user, @@pattern_question]
        end

        def init
          super
          @domain = 'q.hatena.ne.jp'
        end

        def parse(text, opt = {})
          case text
          when @@pattern_user
            _parse_user(text)
          when @@pattern_question
            _parse_question(text)
          end
        end

        def _parse_user(text)
          return if @@pattern_user !~ text
          title, name = $1, $2
          return sprintf('<a href="http://%s/%s/"%s>%s</a>',
                         @domain, name, @a_target_string, title)
        end

        def _parse_question(text)
          return if @@pattern_question !~ text
          title, qid = $1, $2
          return sprintf('<a href="http://%s/%s"%s>%s</a>',
                         @domain, qid, @a_target_string, title)
        end
      end
    end
  end
end
