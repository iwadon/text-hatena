require "text/hatena/auto_link/scheme"

module Text
  class Hatena
    class AutoLink
      class HTTP < Scheme
        @@pattern_simple = /\[?(https?:\/\/[A-Za-z0-9~\/._\?\&=\-%#\+:\;,\@\']+)\]?/i
        @@pattern_useful = /\[(https?:\/\/[A-Za-z0-9~\/._\?\&=\-%#\+:\;,\@\']+?):(title(?:=([^\]]*))?|barcode|detail|image(?::([hw]\d+))?)\]/i

        def patterns
          [@@pattern_useful, @@pattern_simple]
        end

        def parse(text, opt = {})
          case text
          when @@pattern_useful
            _parse_useful(text, opt)
          when @@pattern_simple
            _parse_simple(text)
          else
            # ???
          end
        end

        def _parse_simple(url)
          url.sub!(/^\[/, '')
          url.sub!(/\[$/, '')
          sprintf('<a href="%s"%s>%s</a>', url, @a_target_string, url)
        end

        def _parse_useful(text, opt)
        end
      end
    end
  end
end
