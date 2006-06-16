require "time"
require "text/hatena/node"

module Text
  class Hatena
    class H3Node < Node
      def init
        @pattern = /^\*(?:(\d{9,10}|[a-zA-Z]\w*)\*)?((?:\[[^\:\[\]]+\])+)?(.*)$/
      end

      def parse
        c = @context
        return unless l = c.shiftline
        return unless @pattern =~ l
        name, cat, title = $1, $2, $3
        b = c.baseuri
        p = c.permalink
        t = "\t" * @ilevel
        sa = c.sectionanchor

        if cat
          cat.gsub!(/\[([^\:\[\]]+)\]/e) do
            w = $1
            ew = _encode($1)
            %Q![<a href="#{b}?word=#{ew}" class="sectioncategory">#{w}</a>]!
          end
        end
        name, extra = _formatname(name)
        name ||= ""
        cat ||= ""
        c.htmllines(%Q!#{t}<h3><a href="#{p}\##{name}" name="#{name}"><span class="sanchor">#{sa}</span></a> #{cat}#{title}</h3>#{extra}!)
      end

      def _formatname(name)
        if name and /\A\d{9,10}\Z/ =~ name
          t = Time.at(name.to_i).localtime
          m = sprintf("%02d", t.min)
          h = sprintf("%02d", t.hour)
          return [name, %Q! <span class="timestamp">#{h}:#{m}</span>!]
        elsif name
          return name
        else
          @context.incrementsection
          name = "p#{@context.sectioncount}"
          return name
        end
      end

      def _encode(str)
        return nil if str.nil? or str.empty?
        str.gsub!(/(\W)/e) do
          sprintf("%%%02x", $1[0])
        end
        return str
      end
    end
  end
end
