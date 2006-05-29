require "text/hatena/pre_node"

module Text
  class Hatena
    class SuperpreNode < PreNode
      def init
        @pattern = /^>\|\|$/
        @endpattern = /^\|\|<$/
        @startstring = '<pre class="hatena-super-pre">'
        @endstring = "</pre>"
      end

      def escape_pre(s)
        s.gsub!(/\&/, "\&amp;")
        s.gsub!(/</, "\&lt;")
        s.gsub!(/>/, "\&gt;")
        s.gsub!(/"/, "\&quot;")
        s.gsub!(/\'/, "\&#39;")
        s.gsub!(/\\/, "\&#92;")
        return s
      end
    end
  end
end
