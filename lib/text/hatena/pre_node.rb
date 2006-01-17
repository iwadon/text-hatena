require "text/hatena/node"

module Text
  class Hatena
    class PreNode < Node
      def init
        @pattern = /^>\|$/
        @endpattern = /\|<$/
        @startstring = "<pre>"
        @endstring = "</pre>"
      end

      def parse
        c = @context
        return unless @pattern =~ c.nextline
        c.shiftline
        t = "\t" * @ilevel
        c.htmllines(t + @startstring)
        x = ""
        while c.hasnext
          l = c.nextline
          if @endpattern =~ l
            x = $` || ""
            c.shiftline
            break
          end
          c.htmllines(escape_pre(c.shiftline))
        end
        c.htmllines("#{x}#{@endstring}")
      end

      def escape_pre(arg)
        arg
      end
    end
  end
end
