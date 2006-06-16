require "text/hatena/node"
require "text/hatena/utils/section_node_utils"

module Text
  class Hatena
    class TagNode < Node
      include SectionNodeUtils
      def init
        @childnode = %w(h5 h4 h3 blockquote dl list pre superpre table)
        @pattern = /^>(<.*)$/
        @endpattern = /^(.*>)<$/
      end

      def parse
        c = @context
        t = "\t" * @ilevel
        return unless c.nextline =~ /#{@pattern}/
        c.shiftline
        c.noparagraph(true)
        _set_child_node_refs
        x = _parse_text($1)
        c.htmllines(t + x)
        while c.hasnext
          l = c.nextline
          if l =~ @endpattern
            c.shiftline
            x = _parse_text($1)
            c.htmllines(t + x)
            break
          end
          node = _findnode(l)
          node.parse if node
        end
        c.noparagraph(false)
      end

      def _parse_text(l)
        text = Text.new(:context => @context)
        text.parse(l)
        return text.html
      end
    end
  end
end
