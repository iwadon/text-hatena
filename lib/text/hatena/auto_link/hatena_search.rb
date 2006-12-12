require "text/hatena/auto_link/scheme"

module Text
  class Hatena
    class AutoLink
      class HatenaSearch < Scheme
        @@pattern = /\[search:(?:(keyword|question|asin|web):)?([^\]]+?)\]/i

        def patterns
          [@@pattern]
        end

        def init
          super
          @domain = 'search.hatena.ne.jp'
        end

        def parse(text, opt)
          return if @@pattern !~ text
          type, word = $1, $2
          enword = html_encode(word)
          case type.to_s.downcase
          when 'question'
            return sprintf('<a href="http://%s/questsearch?word=%s&ie=utf8"%s>search:%s:%s</a>',
                           @domain, enword, @a_target_string,
                           type, word)
          when 'asin'
            return sprintf('<a href="http://%s/asinsearch?word=%s&ie=utf8"%s>search:%s:%s</a>',
                           @domain, enword, @a_target_string,
                           type, word)
          when 'web'
            return sprintf('<a href="http://%s/websearch?word=%s&ie=utf8"%s>search:%s:%s</a>',
                           @domain, enword, @a_target_string,
                           type, word)
          else
            return sprintf('<a href="http://%s/keyword?word=%s&ie=utf8"%s>search:%s%s</a>',
                           @domain, enword, @a_target_string,
                           type ? "#{type}:" : '', word)
          end
        end
      end
    end
  end
end
