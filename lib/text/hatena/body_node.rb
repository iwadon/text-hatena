require "text/hatena/footnote_node"
require "text/hatena/node"
require "text/hatena/section_node"

module Text
  class Hatena
    class BodyNode < Node
      def parse
        while @context.hasnext
          node = SectionNode.new({ :context => @context,
                                   :ilevel => @ilevel })
          node.parse
        end
        if @context.footnotes
          node = FootnoteNode.new({ :context => @context,
                                    :ilevel => @ilevel })
          node.parse
        end
      end
    end
  end
end
