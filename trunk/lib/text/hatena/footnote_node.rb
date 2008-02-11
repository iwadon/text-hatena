require "text/hatena/node"
require "text/hatena/text"

module Text
  class Hatena
    class FootnoteNode < Node
      def parse
        c = @context
        return if c.footnotes.empty?
        t = "\t" * @ilevel
        p = c.permalink
        @html = ""

        @html << %Q!#{t}<div class="footnote">\n!
        i = 0
        text = Text.new({:context => @context})
        c.footnotes.each do |note|
          i += 1
          text.parse(note)
          l = %Q!#{t}\t<p class="footnote"><a href="#{p}#fn#{i}" name="f#{i}">*#{i}</a>: ! +
            text.html +
            "</p>"
          @html << "#{l}\n"
        end
        @html << %Q!#{t}</div>\n!
      end

      def html
        @html
      end
    end
  end
end
