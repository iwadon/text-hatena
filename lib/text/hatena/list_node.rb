require "text/hatena/node"

module Text
  class Hatena
    class ListNode < Node
      def init
        @pattern = /^([\-\+]+)([^>\-\+].*)$/
      end

      def parse
        c = @context
        l = c.nextline
        return unless @pattern =~ l
        @llevel = $1.size
        t = "\t" * (@ilevel + @llevel - 1)
        @type = $1[-1, 1] == "-" ? "ul" : "ol"

        c.htmllines("#{t}<#{@type}>")
        while l = c.nextline
          break unless @pattern =~ l
          if $1.size > @llevel
            c.htmllines("#{t}\t<li>")
            node = self.class.new({ :context => @context,
                                    :ilevel => @ilevel })
            node.parse
            c.htmllines("#{t}\t</li>")
          elsif $1.size < @llevel
            break
          else
            l = c.shiftline
            c.htmllines("#{t}\t<li>#{$2}</li>")
          end
        end
        c.htmllines("#{t}</#{@type}>")
      end
    end
  end
end
