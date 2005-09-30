require "text/hatena/node"

module Text
  class Hatena
    class PreNode < Node
      def init
        @pattern = /^>\|$/
        @endpattern = /^\|<$/
        @startstring = "<pre>"
        @endstring = "</pre>"
      end

      def parse
        c = @context
        return unless @pattern =~ c.nextline
        c.shiftline
        t = "\t" * @ilevel
        c.htmllines(t + @startstring)
        while c.hasnext
          l = c.nextline
          if @endpattern =~ l
            c.shiftline
            break
          end
          c.htmllines(c.shiftline)
        end
        c.htmllines(@endstring)
      end
    end
  end
end
