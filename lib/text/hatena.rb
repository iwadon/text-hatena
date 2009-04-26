require "text/hatena/body_node"
require "text/hatena/context"
require "text/hatena/html_filter"

module Text
  class Hatena
    VERSION = "0.12"

    def initialize(args = {})
      @html = ""
      @baseuri = args[:baseuri] || ""
      @permalink = args[:permalink] || ""
      @ilevel = Integer(args[:ilevel]) || 0 # level of default indent
      @invalidnode = args[:invalidnode] || []
      @sectionanchor = args[:sectionanchor] || "o-"
      @autolink_option = args[:autolink_option] || {}
      @texthandler = args[:texthandler] || Proc.new do |text, c, hp|
        if hp.in_anchor or hp.in_superpre
          text
        else
          p = c.permalink
          al = c.autolink
          text = al.parse(text, {
                            :in_paragraph => hp.in_paragraph
                          })
          text
        end
      end
      @htmlfilter_option = args[:htmlfilter_option] || {}
    end

    def parse(text)
      return if text.nil? or text.empty?
      @context = Context.new({ :text => text,
                               :baseuri => @baseuri,
                               :permalink => @permalink,
                               :invalidnode => @invalidnode,
                               :sectionanchor => @sectionanchor,
                               :autolink_option => @autolink_option,
                               :texthandler => @texthandler })
      c = @context
      node = BodyNode.new({ :context => c,
                            :ilevel => @ilevel })
      node.parse

      parser = HTMLFilter.new({ :context => c }.merge(@htmlfilter_option))
      parser.parse(c.html)
      @html = parser.html
      
      unless c.footnotes.empty?
        node = FootnoteNode.new({ :context => c, :ilevel => @ilevel })
        node.parse
        @html << "\n"
        @html << node.html
      end
    end

    def html
      @html
    end
  end
end
