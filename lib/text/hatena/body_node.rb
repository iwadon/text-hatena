require "text/hatena/footnote_node"
require "text/hatena/node"
require "text/hatena/section_node"

module Text
  class Hatena
    class BodyNode < Node
      def parse
        c = @context
        while c.hasnext
          node = SectionNode.new({ :context => c,
                                   :ilevel => @ilevel })
          node.parse
        end
      end
    end
  end
end
