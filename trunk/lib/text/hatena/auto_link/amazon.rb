require "kconv"
require "text/hatena/auto_link/scheme"

module Text
  class Hatena
    class AutoLink
      class Amazon < Scheme
        @@pattern = /\[amazon:([^\]]+?)\]/i

        def patterns
          [@@pattern]
        end

        def init
          super
          @domain = @option[:domain] || 'www.amazon.co.jp'
          @amazon_affiliate_id = @option[:amazon_affiliate_id] || 'hatena-22'
        end

        def parse(text, opt)
          return if @@pattern !~ text
          word = $1
          return sprintf('<a href="http://%s/exec/obidos/external-search?mode=blended&tag=%s&encoding-string-jp=%s&keyword=%s"%s>amazon:%s</a>',
                         @domain, @amazon_affiliate_id,
                         html_encode('\346\227\245\346\234\254\350\252\236'), html_encode(word),
                         @a_target_string, word)
        end
      end
    end
  end
end
