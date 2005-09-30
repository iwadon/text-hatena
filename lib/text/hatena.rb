require "text/hatena/body_node"
require "text/hatena/context"

module Text
  class Hatena
    VERSION = "0.01"

    def initialize(args = {})
      @baseuri = args[:baseuri] || ""
      @permalink = args[:permalink] || ""
      @ilevel = Integer(args[:ilevel]) || 0 # level of default indent
      @invalidnode = args[:invalidnode] || []
      @sectionanchor = args[:sectionanchor] || "o-"
    end

    def parse(text)
      return if text.nil? or text.empty?
      @context = Context.new({ :text => text,
                               :baseuri => @baseuri,
                               :permalink => @permalink,
                               :invalidnode => @invalidnode,
                               :sectionanchor => @sectionanchor })
      node = BodyNode.new({ :context => @context,
                            :ilevel => @ilevel })
      node.parse
    end

    def html
      @context.html
    end
  end
end
