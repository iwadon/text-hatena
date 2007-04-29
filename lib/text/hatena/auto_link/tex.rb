require "text/hatena/auto_link/scheme"

module Text
  class Hatena
    class AutoLink
      class Tex < Scheme
        @@pattern = /\[tex:(.*?[^\\\\])\]/i

        def patterns
          [@@pattern]
        end

        def parse(text, opt = {})
          return if @@pattern !~ text
          alt = escape_attr($1)
          tex = $1
          tex.gsub!(/\\([\[\]])/, '\1')
          tex.gsub!(/\s/, '~')
          tex.gsub!(/"/, '&quot;')
          return sprintf('<img src="http://d.hatena.ne.jp/cgi-bin/mimetex.cgi?%s" class="tex" alt="%s">',
                         tex, alt)
        end
      end
    end
  end
end
