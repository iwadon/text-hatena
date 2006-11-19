require "text/hatena/auto_link/scheme"

module Text
  class Hatena
    class AutoLink
      class Mailto < Scheme
        @@pattern = /\[?mailto:([a-zA-Z0-9_][a-zA-Z0-9_\.\-]+\@[a-zA-Z0-9_]+[a-zA-Z0-9_\.\-]*[a-zA-Z0-9_])\]?/i

        def patterns
          [@@pattern]
        end

        def parse(text, opt)
          return unless @@pattern =~ text
          addr = $1
          return sprintf('<a href="mailto:%s">mailto:%s</a>',
                         addr,
                         addr
                         )
        end
      end
    end
  end
end
