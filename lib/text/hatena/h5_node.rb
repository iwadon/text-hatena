require "text/hatena/node"

module Text
  class Hatena
    class H5Node < Node
      def init
        @pattern = /^\*\*\*((?:[^\*]).*)$/
      end

      def parse
        c = @context
        return nil unless l = c.shiftline
        return nil unless @pattern =~ l
        t = "\t" * @ilevel
        c.htmllines("#{t}<h5>#{$1}</h5>")
      end
    end
  end
end
