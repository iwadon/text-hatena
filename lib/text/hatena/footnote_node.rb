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

        c.htmllines(%Q!#{t}<div class="footnote">!)
        i = 0
        text = Text.new({:context => @context})
        c.footnotes.each do |note|
          i += 1
          text.parse(note)
          l = %Q!#{t}<p class="footnote"><a href="#{p}#fn#{i}" name="f#{i}">*#{i}</a>: ! +
            text.html +
            "</p>"
          c.htmllines(l)
        end
        c.htmllines("#{t}</div>")
      end
    end
  end
end
