module Text
  class Hatena
    class Text
      def initialize(args = {})
        @context = args[:context]
        @html = ""
      end

      def parse(text)
        @html = ""
        return unless text
        @html = text
        c = @context
        p = c.permalink
        @html.gsub!(/\(\((.+?)\)\)/) do
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
      end

      def html
        @html
      end
    end
  end
end

        
