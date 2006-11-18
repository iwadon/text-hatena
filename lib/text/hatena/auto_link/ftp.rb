require "text/hatena/auto_link/scheme"

module Text
  class Hatena
    class AutoLink
      class FTP < Scheme
        @@pattern = /\[?(ftp:\/\/[A-Za-z0-9~\/._\?\&=\-%#\+:\;,\@\']+)\]?/i # /

        def patterns
          [@@pattern]
        end

        def parse(url, opt)
          sprintf('<a href="%s"%s>%s</a>', url, @a_target_string, url)
        end
      end
    end
  end
end
