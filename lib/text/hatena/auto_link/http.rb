require "open-uri"
require "text/hatena/auto_link/scheme"

module Text
  class Hatena
    class AutoLink
      class HTTP < Scheme
        @@pattern_simple = /\[?(https?:\/\/[A-Za-z0-9~\/._\?\&=\-%#\+:\;,\@\'\(\)\!]+)\]?/i
        @@pattern_useful = /\[(https?:\/\/[A-Za-z0-9~\/._\?\&=\-%#\+:\;,\@\'\(\)\!]+?):(title(?:=([^\]]*))?|barcode|detail|image(?::([hw]\d+))?)\]/i

        def patterns
          [@@pattern_useful, @@pattern_simple]
        end

        def parse(text, opt = {})
          case text
          when @@pattern_useful
            return _parse_useful(text, opt)
          when @@pattern_simple
            return _parse_simple(text)
          end
        end

        def _parse_simple(url)
          return nil if url.nil? or url.empty?
          url.sub!(/^\[/, '')
          url.sub!(/\]$/, '')
          sprintf('<a href="%s"%s>%s</a>', url, @a_target_string, url)
        end

        def _parse_useful(text, opt)
          return unless @@pattern_useful =~ text
          url, type, title, size = $1, $2, $3, $4
          case type
          when /^title/i
            title ||= _get_page_title(url)
            sprintf('<a href="%s"%s>%s</a>', url, @a_target_string, title)
          when /^detail/i
            title ||= _get_page_title(url)
            html = sprintf('<div class="hatena-http-detail"><p class="hatena-http-detail-url"><a href="%s"%s>%s</a></p><p class="hatena-http-detail-title">%s</p></div>', url, @a_target_string, url, title)
            html = "</p>#{html}<p>" if opt[:in_paragraph]
            html
          when /^image/i
            if /\.(jpe?g|gif|png|bmp)$/i =~ url
              size_string = ""
              if /^h(\d+)$/i =~ size
                size_string = sprintf(' height="%s"', $1)
              elsif /^w(\d+)$/i =~ size
                size_string = sprintf(' width="%s"', $1)
              end
              sprintf('<a href="%s"%s><img src="%s" alt="%s" class="hatena-http-image"%s></a>',
                      url,
                      @a_target_string,
                      url,
                      url,
                      size_string
                      )
            else
              sprintf('<a href="%s"%s>%s</a>',
                      url,
                      @a_target_string,
                      url
                      )
            end
          when /^barcode/i
            str = html_encode(url)
            sprintf('<a href="%s"%s><img src="http://d.hatena.ne.jp/barcode?str=%s" class="barcode" alt="%s"></a>',
                    url,
                    @a_target_string,
                    str,
                    url)
          end
        end

        private

        def _get_page_title(url)
          begin
            open(url) do |f|
              content = f.read(131072) # 2^17
              return "#{url} (notitle)" unless /<title.*?>(.*?)<\/title>/i =~ content
              title = $1
              if h = @option[:title_handler]
                if /charset="?(.+?)"?$/i =~ f.content_type
                  cset = $1.downcase
                elsif /<meta[^>]+charset="?([\w\d\s\-]+)"?/i =~ content
                  cset = $1.downcase
                end
                title = h.call(title, cset)
              end
              return title
            end
          rescue Timeout::Error
            return "#{url} (timeout)"
          rescue Exception => e
            return "#{url} (#{e.message})"
          end
        end
      end
    end
  end
end
