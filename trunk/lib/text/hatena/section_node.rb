require "text/hatena/br_node"
require "text/hatena/node"
require "text/hatena/p_node"
require "text/hatena/tagline_node"
require "text/hatena/tag_node"
require "text/hatena/cdata_node"
require "text/hatena/utils/section_node_utils"

module Text
  class Hatena
    class SectionNode < Node
      include SectionNodeUtils

      def init
        @childnode = %w(h5 h4 h3 blockquote dl list superpre pre table tagline tag)
        @startstring = %Q!<div class="section">!
        @endstring = %Q!</div>!
        @started = false
      end

      def parse
        c = @context
        t = "\t" * @ilevel
        _set_child_node_refs
        c.htmllines(t + @startstring)
        while c.hasnext
          l = c.nextline
          break unless node = _findnode(l)
          if node.is_a?(H3Node)
            break if @started
            @started = true
          end
          node.parse
        end
        c.htmllines(t + @endstring)
      end
    end
  end
end
