require "text/hatena/body_node"
require "text/hatena/context"
require "text/hatena/html_filter"

module Text
  class Hatena
    VERSION = "0.06"

    def initialize(args = {})
      @html = ""
      @baseuri = args[:baseuri] || ""
      @permalink = args[:permalink] || ""
      @ilevel = Integer(args[:ilevel]) || 0 # level of default indent
      @invalidnode = args[:invalidnode] || []
      @sectionanchor = args[:sectionanchor] || "o-"
      @texthandler = args[:texthandler] || Proc.new{|text, c|
        text.gsub!(/\(\((.+?)\)\)/eo) do
          note, pre, post = $1, $`, $'
          if pre == ")" and post == "("
            "((#{note}))"
          else
            notes = c.footnotes(note)
            num = notes.size
            note.gsub!(/<.*?>/, "")
            note.gsub!(/&/, "&amp;")
            %Q!<span class="footnote"><a href="#{p}#f#{num}" title="#{note}" name="fn#{num}">*#{num}</a></span>!
          end
        end
      }
    end

    def parse(text)
      return if text.nil? or text.empty?
      @context = Context.new({ :text => text,
                               :baseuri => @baseuri,
                               :permalink => @permalink,
                               :invalidnode => @invalidnode,
                               :sectionanchor => @sectionanchor, 
                               :texthandler => @texthandler })
      c = @context
      node = BodyNode.new({ :context => c,
                            :ilevel => @ilevel })
      node.parse

      parser = HTMLFilter.new({ :context => c })
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
