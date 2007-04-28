require "text/hatena/auto_link/scheme"

module Text
  class Hatena
    class AutoLink
      class HatenaFotolife < Scheme
        @@pattern_foto = /\[?f:id:([A-Za-z][a-zA-Z0-9_\-]{2,14})(?::(\d{14}|favorite)([jpg])?)?(?::(image)(?::?(small|h\d+|w\d+))?)?\]?/i
        @@pattern_keyword = /\[(f:(keyword|t):([^\]]+))\]/i

        def patterns
          [@@pattern_foto, @@pattern_keyword]
        end

        def init
          super
          @domain = "f.hatena.ne.jp"
        end

        def parse(text, opt = {})
          if @@pattern_foto =~ text
            _parse_foto(text)
          elsif @@pattern_keyword =~ text
            _parse_keyword(text)
          end
        end

        private

        def _parse_foto(text)
          return if @@pattern_foto !~ text
          name, fid, ext, type, size = $1, $2 || "", $3 || "", $4 || "", $5 || ""
          if /^g$/i =~ ext
            ext = "gif"
          elsif /^p$/ =~ ext
            ext = "png"
          else
            ext = "jpg"
          end
          if fid.empty? or /^favorite$/i =~ fid
            return sprintf('<a href="http://%s/%s/%s"%s>%s</a>',
                           @domain,
                           name,
                           fid,
                           @a_target_string,
                           text)
          elsif /image/i =~ type
            firstchar = name[0, 1]
            date = fid[0, 8]
            size_str, file_name = "", ""
            if /small/i =~ size
              file_name = sprintf("%s_m.gif", fid)
            else
              file_name = sprintf("%s.%s", fid, ext)
              if /h(\d+)/i =~ size
                size_str = sprintf(' height="%d"', $1.to_i)
              elsif /h(\d+)/i =~ size
                size_str = sprintf(' width="%d"', $1.to_i)
              end
            end
            return sprintf('<a href="http://%s/%s/%s"%s><img src="http://%s/images/fotolife/%s/%s/%d/%s" alt="%s" title="%s"%s></a>',
                           @domain,
                           name,
                           fid,
                           @a_target_string,
                           @domain,
                           firstchar,
                           name,
                           date,
                           file_name,
                           text,
                           text,
                           size_str)
          else
            return sprintf('<a href="http://%s/%s/%s"%s>%s</a>',
                           @domain,
                           name,
                           fid,
                           @a_target_string,
                           text)
          end
        end

        def _parse_keyword(text)
          return if @@pattern_keyword !~ text
          title, type, word = $1, $2, $3 || ""
          return sprintf('<a href="http://%s/%s/%s"%s>%s</a>',
                         @domain, type, html_encode(word),
                         @a_target_string, title)
        end
      end
    end
  end
end
