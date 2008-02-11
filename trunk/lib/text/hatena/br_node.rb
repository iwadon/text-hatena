require "text/hatena/node"

module Text
  class Hatena
    class BrNode < Node
      def parse
        c = @context
        l = c.shiftline
        return unless l.empty?
        t = "\t" * @ilevel
        if c.lasthtmlline == "#{t}<br>" or c.lasthtmlline == t
          c.htmllines("#{t}<br>")
        else
          c.htmllines(t)
        end
      end
    end
  end
end
