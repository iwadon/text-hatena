module Text
  class Hatena
    module SectionNodeUtils
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
        elsif @context.noparagraph
          return CDataNode.new(nodeoption)
        else
          return PNode.new(nodeoption)
        end
      end
    end
  end
end
