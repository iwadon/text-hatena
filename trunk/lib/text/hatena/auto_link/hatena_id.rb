require 'text/hatena/auto_link/scheme'

module Text
  class Hatena
    class AutoLink
      class HatenaID < Scheme
        @@pattern = /\[?(id:([A-Za-z][a-zA-Z0-9_\-]{2,14})(?::(detail|image))?)\]?/i

        def patterns
          [@@pattern]
        end

        def parse(text, opt = {})
          return if @@pattern !~ text
          content, name, type = $1, $2, $3 || ''
          case type
          when 'image'
            pre = name[0, 2]
            return sprintf('<a href="/%s/"%s><img src="http://www.hatena.ne.jp/users/%s/%s/profile.gif" width="60" height="60" alt="id:%s" class="hatena-id-image"></a>',
                           name, @a_target_string, pre, name, name)
          when 'detail'
            pre = name[0, 2]
            return sprintf('<a href="/%s/"%s><img src="http://www.hatena.ne.jp/users/%s/%s/profile.gif" width="16" height="16" alt="id:%s" class="hatena-id-icon">id:%s</a>',
                           name, @a_target_string, pre, name,
                           name, name)
          else
            sprintf('<a href="/%s/"%s>%s</a>',
                    name, @a_target_string, content)
          end
        end
      end
    end
  end
end
