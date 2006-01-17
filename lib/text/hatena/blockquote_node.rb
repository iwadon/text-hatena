require "text/hatena/section_node"

module Text
  class Hatena
    class BlockquoteNode < SectionNode
      def init
        @pattern = /^>>$/
        @endpattern = /^<<$/
        @childnode = %w(h4 h5 blockquote dl list pre superpre table tagline tag)
        @startstring = "<blockquote>"
        @endstring = "</blockquote>"
      end

      def parse
        c = @context
        return unless @pattern =~ c.nextline
        c.shiftline
        t = "\t" * @ilevel
        _set_child_node_refs
        c.htmllines(t + @startstring)
        while c.hasnext
          l = c.nextline
          if @endpattern =~ l
            c.shiftline
            break
          end
          break unless node = _findnode(l)
          node.parse
        end
        c.htmllines(t + @endstring)
      end
    end
  end
end
