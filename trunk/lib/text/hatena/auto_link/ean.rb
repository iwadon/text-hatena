require "text/hatena/auto_link/scheme"

module Text
  class Hatena
    class AutoLink
      class EAN < Scheme
        @@pattern_title = /\[(ean|jan):(\d{8,13}):title=(.+?)\]/i
        @@pattern_simple = /\[?(ean|jan):(\d{8,13})\]?/i

        def patterns
          [@@pattern_title, @@pattern_simple]
        end

        def init
          super
          @asin_url = 'http://d.hatena.ne.jp/ean/'
        end

        def parse(text, opt = {})
          case text
          when @@pattern_title
            _parse_title(text)
          when @@pattern_simple
            _parse_simple(text)
          end
        end

        def _parse_title(text)
          return if @@pattern_title !~ text
          scheme, eancode, title = $1, $2, $3
          return text unless check_digit(eancode)
          return sprintf('<a href="%s%s"%s>%s</a>',
                         @asin_url, eancode, @a_target_string, title)
        end

        def _parse_simple(text)
          return if @@pattern_simple !~ text
          scheme, eancode = $1, $2
          return sprintf('<a href="%s%s"%s>%s:%s</a>',
                         @asin_url, eancode, @a_target_string,
                         scheme, eancode)
        end

        def check_digit(ean)
          length = ean.size
          return unless length == 8 or length == 13
          odd = even = 0
          length.times do |i|
            num = ean[length - i - 2, 1].to_i
            if i % 2 != 0
              odd += num
            else
              even += num
            end
          end
          digit = 10 - ((odd + (even * 3)) % 10)
          return ean[-1, 1].to_i == digit % 10
        end
      end
    end
  end
end
