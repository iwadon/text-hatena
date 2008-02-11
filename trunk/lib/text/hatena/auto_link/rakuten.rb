require "kconv"
require "text/hatena/auto_link/scheme"

module Text
  class Hatena
    class AutoLink
      class Rakuten < Scheme
        @@pattern = /\[rakuten:([^\]]+?)\]/i

        def patterns
          [@@pattern]
        end

        def parse(text, opt)
          return if @@pattern !~ text
          word = $1
          return sprintf('<a href="http://pt.afl.rakuten.co.jp/c/002e8f0a.89099887/?sv=2&v=3&p=0&sitem=%s"%s>rakuten:%s</a>',
                         html_encode(word.toeuc),
                         @a_target_string, word)
        end
      end
    end
  end
end
