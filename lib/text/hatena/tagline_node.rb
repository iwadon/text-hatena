require 'text/hatena/node'

module Text
  class Hatena
    class TaglineNode < Node
      def init
        @pattern = /^>(<.*>)<$/
      end

      def parse
        c = @context
        t = "\t" * @ilevel
        return unless c.nextline =~ /#{@pattern}/
        c.shiftline
        c.htmllines(t + $1)
      end
    end
  end
end
