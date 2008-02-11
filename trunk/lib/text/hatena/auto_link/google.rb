require "text/hatena/auto_link/scheme"

module Text
  class Hatena
    class AutoLink
      class Google < Scheme
        @@pattern = /\[google:(?:(news|images?):)?([^\]]+?)\]/i

        def patterns
          [@@pattern]
        end

        def parse(text, opts)
          return unless @@pattern =~ text
          type, word = $1 || "", $2
          if type.downcase == 'news'
            return sprintf('<a href="http://news.google.com/news?q=%s&ie=utf-8&oe=utf-8"%s>google:%s:%s</a>',
                           html_encode(word), @a_target_string,
                           type, word)
          elsif /^images?$/i =~ type
            return sprintf('<a href="http://images.google.com/images?q=%s&ie=utf-8&oe=utf-8"%s>google:%s:%s</a>',
                           html_encode(word), @a_target_string,
                           type, word)
          else
            return sprintf('<a href="http://www.google.com/search?q=%s&ie=utf-8&oe=utf-8"%s>google:%s</a>',
                           html_encode(word), @a_target_string, word)
          end
        end
      end
    end
  end
end
