require "text/hatena/node"

module Text
  class Hatena
    class DlNode < Node
      def init
        @pattern = /^\:((?:<[^>]+>|\[\].+?\[\]|\[[^\]]+\]|\[\]|[^\:<\[])+)\:(.+)$/
      end

      def parse
        c = @context
        l = c.nextline
        return unless @pattern =~ l
        @llevel = $1.size
        t = "\t" * @ilevel

        c.htmllines("#{t}<dl>")
        while l = c.nextline
          break if @pattern !~ l
          c.shiftline
          c.htmllines("#{t}\t<dt>#{$1}</dt>")
          c.htmllines("#{t}\t<dd>#{$2}</dd>")
        end
        c.htmllines("#{t}</dl>")
      end
    end
  end
end
