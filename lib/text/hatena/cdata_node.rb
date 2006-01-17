require "text/hatena/node"

module Text
  class Hatena
    class CDataNode < Node
      def parse
        c = @context
        l = c.shiftline
        t = "\t" * @ilevel
        #if c.lasthtmlline == "#{t}<br>" or c.lasthtmlline == t
        #  c.htmllines("#{t}<br>")
        #else
        #  c.htmllines(t)
        #end
        text = Text.new({:context => @context})
        text.parse(l)
        l = text.html
        c.htmllines("#{t}#{l}")
      end
    end
  end
end
