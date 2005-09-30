require "text/hatena/br_node"
require "text/hatena/node"
require "text/hatena/p_node"

module Text
  class Hatena
    class SectionNode < Node
      def init
        @childnode = %w(h5 h4 h3 blockquote dl list pre superpre table)
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

      def _set_child_node_refs
        c = @context
        nodeoption = {
          :context => c,
          :ilevel => @ilevel + 1,
        }
        invalid = {}
        c.invalidnode.each do |node|
          invalid[node] = {}
        end
        @childnode.each do |node|
          next if invalid.key?(node)
          require "text/hatena/" + node.downcase + "_node"
          mod = ::Text::Hatena.const_get(node.capitalize + "Node")
          (@child_node_refs ||= []).push(mod.new(nodeoption))
        end
      end

      def _findnode(l)
        @child_node_refs.each do |node|
          next unless pat = node.pattern
          if pat =~ l
            return node
          end
        end
        nodeoption = {
          :context => @context,
          :ilevel => @ilevel + 1,
        }
        if l.empty?
          return BrNode.new(nodeoption)
        else
          return PNode.new(nodeoption)
        end
      end
    end
  end
end
