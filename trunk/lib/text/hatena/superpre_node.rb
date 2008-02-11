require "text/hatena/pre_node"

module Text
  class Hatena
    class SuperpreNode < PreNode
      begin
        begin
          require 'vimcolor'
        rescue LoadError
          require 'rubygems'
          require 'vimcolor'
        end
        Formatter = ::VimColor
      rescue LoadError
        class Formatter
          def run(str, filetype, formatter_class, *formatter_args)
            str
          end
        end
      end

      def init
        @pattern = /^>\|([^\|]*)\|$/
        @endpattern = /^\|\|<$/
        @startstring = '<pre class="hatena-super-pre">'
        @endstring = "</pre>"
        @formatter = Formatter.new
      end

      def parse
        c = @context
        return unless @pattern =~ c.nextline
        filetype = $1
        c.shiftline
        t = "\t" * @ilevel
        c.htmllines(t + @startstring)
        x = ""
        txt = ''
        while c.hasnext
          l = c.nextline
          if @endpattern =~ l
            x = $` || ""
            c.shiftline
            break
          end
          #c.htmllines(escape_pre(c.shiftline))
          txt << c.shiftline << "\n"
        end
        unless txt.empty?
          options = {:encoding => 'utf-8'}
          options[:filetype] = filetype if filetype
          @formatter.run(txt, options, :html).each_line do |line|
            line.chomp!
            c.htmllines(line)
          end
        end
        c.htmllines("#{x}#{@endstring}")
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
