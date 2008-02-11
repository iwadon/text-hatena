require "text/hatena/node"
require "text/hatena/text"

module Text
  class Hatena
    class PNode < Node
      def parse
        c = @context
        t = "\t" * @ilevel
        l = c.shiftline
        text = Text.new({:context => @context})
        text.parse(l)
        l = text.html
        c.htmllines("#{t}<p>#{l}</p>")
      end
    end
  end
end
