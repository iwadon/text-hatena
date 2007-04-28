require "text/hatena/auto_link/scheme"

module Text
  class Hatena
    class AutoLink
      class HatenaRSS < Scheme
        @@pattern = /\[?(r:id:([A-Za-z][a-zA-Z0-9_\-]{2,14}))\]?/i

        def patterns
          [@@pattern]
        end

        def init
          super
          @domain = 'r.hatena.ne.jp'
        end

        def parse(text, opt = {})
          return if @@pattern !~ text
          return sprintf('<a href="http://%s/%s/"%s>%s</a>',
                         @domain, $2, @a_target_string, $1)
        end
      end
    end
  end
end
