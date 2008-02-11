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
        @open = 0
        while l = c.nextline
          break unless @pattern =~ l
          if $1.size > @llevel
            #c.htmllines("#{t}\t<li>")
            node = self.class.new({ :context => @context,
                                    :ilevel => @ilevel })
            node.parse
            #c.htmllines("#{t}\t</li>")
          elsif $1.size < @llevel
            break
          else
            #l = c.shiftline
            #c.htmllines("#{t}\t<li>#{$2}</li>")
            _closeitem unless @open.zero?
            c.shiftline
            nl = c.nextline
            content = $2
            text = Text.new({:context => @context})
            text.parse(content)
            content = text.html
            if nl =~ @pattern && $1.size > @llevel
              c.htmllines("#{t}\t<li>#{content}")
              @open += 1
            else
              c.htmllines("#{t}\t<li>#{content}</li>")
            end
          end
        end
        _closeitem unless @open.zero?
        c.htmllines("#{t}</#{@type}>")
      end

      def _closeitem
        t = "\t" * (@ilevel + @llevel -1)
        @context.htmllines("#{t}\t</li>")
        @open = 0
      end
    end
  end
end
