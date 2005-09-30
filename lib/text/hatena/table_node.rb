require "text/hatena/node"

module Text
  class Hatena
    class TableNode < Node
      def init
        @pattern = /^\|([^\|]*\|(?:[^\|]*\|)+)$/
      end

      def parse
        c = @context
        l = c.nextline
        return unless @pattern =~ l
        t = "\t" * @ilevel

        c.htmllines("#{t}<table>")
        while l = c.nextline
          break unless @pattern =~ l
          l = c.shiftline
          c.htmllines("#{t}\t<tr>")
          l.scan(/([^\|]+)\|/) do |$_, *|
            if sub!(/^\*/, "")
              c.htmllines("#{t}\t\t<th>#{$_}</th>")
            else
              c.htmllines("#{t}\t\t<td>#{$_}</td>")
            end
          end
          c.htmllines("#{t}\t</tr>")
        end
        c.htmllines("#{t}</table>")
      end
    end
  end
end
