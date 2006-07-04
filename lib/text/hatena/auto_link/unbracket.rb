require "text/hatena/auto_link/scheme"

module Text
  class Hatena
    class AutoLink
      class Unbracket < Scheme
        @@pattern = /\[\](.+?)\[\]/i
        
        def patterns
          [@@pattern]
        end

        def parse(text, opt = {})
          if @@pattern =~ text
            $1
          else
            nil
          end
        end
      end
    end
  end
end
