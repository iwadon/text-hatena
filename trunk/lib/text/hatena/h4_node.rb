require "text/hatena/node"

module Text
  class Hatena
    class H4Node < Node
      def init
        @pattern = /^\*\*((?:[^\*]).*)$/
      end

      def parse
        c = @context
        return nil unless l = c.shiftline
        return nil unless @pattern =~ l
        t = "\t" * @ilevel
        c.htmllines("#{t}<h4>#{$1}</h4>")
      end
    end
  end
end
