require "open-uri"
require "amazon/search"
require "text/hatena/auto_link/scheme"

module Text
  class Hatena
    class AutoLink
      class ASIN < Scheme
        @@pattern_asin_title = /\[(isbn|asin):([\w\-]{10,16}):title=(.*?)\]/i
        @@pattern_asin = /\[?(isbn|asin):([\w\-]{10,16}):?(image|detail|title)?:?(small|large)?\]?/i
        @@detail_template = <<END
<div class="hatena-asin-detail">
  <a href="<% asin_url | uri %>"><img src="<% property.ImageUrlSmall || property.ImageUrlLarge || property.ImageUrlMedium | utf8off | uri %>" class="hatena-asin-detail-image" alt="<% title | utf8off | html %>" title="<% title | utf8off | html %>"></a>
  <div class="hatena-asin-detail-info">
  <p class="hatena-asin-detail-title"><a href="<% asin_url | uri %>"><% title | utf8off | html %></a></p>
  <ul>
    <% IF property.artists %><li><span class="hatena-asin-detail-label">アーティスト:</span> <% FOREACH artist = property.artists %><a href="<% keyword_url %><% artist | utf8off | enword %>" class="keyword"><% artist | utf8off | html %></a> <% END %></li><% END %>
    <% IF property.authors %><li><span class="hatena-asin-detail-label">作者:</span> <% FOREACH author = property.authors %><a href="<% keyword_url %><% author | utf8off | enword %>" class="keyword"><% author | utf8off | html %></a> <% END %></li><% END %>
    <% IF property.publisher %><li><span class="hatena-asin-detail-label">出版社/メーカー:</span> <a href="<% keyword_url %><% property.publisher | utf8off | enword %>" class="keyword"><% property.publisher | utf8off | html %></a></li><% END %>
    <% IF property.ReleaseDate %><li><span class="hatena-asin-detail-label">発売日:</span> <% property.ReleaseDate | utf8off | html %></li><% END %>
    <li><span class="hatena-asin-detail-label">メディア:</span> <% property.Media | utf8off | html %></li>
  </ul>
</div>
<div class="hatena-asin-detail-foot"></div>
</div>
END

        def patterns
          [@@pattern_asin_title, @@pattern_asin]
        end

        def init
          super
          @asin_url = "http://d.hatena.ne.jp/asin/"
          @keyword_url = "http://d.hatena.ne.jp/keyword/"
          @amazon_token = @option[:amazon_token] || "D3TT1SUCX72K1N"
          @amazon_locale = @option[:amazon_locale] || "jp"
          @amazon_affiliate_id = @option[:amazon_affiliate_id] || "hatena-22"
          @affiliate_path = @option[:amazon_affiliate_id] ? ("/" << @amazon_affiliate_id) : ""
        end

        def parse(text, opt = {})
          case text
          when @@pattern_asin_title
            return _parse_asin_title(text)
          when @@pattern_asin
            return _parse_asin(text, opt)
          end
        end

        def _parse_asin_title(text)
          return if @@pattern_asin_title !~ text
          scheme, asincode, title = $1, $2, $3
          asincode.gsub!(/\-/, "")
          title ||= get_asin_title(asincode) || "#{scheme}:#{asincode}"
          return sprintf('<a href="%s%s%s"%s>%s</a>',
                         @asin_url,
                         asincode,
                         @affiliate_path,
                         @a_target_string,
                         title)
        end

        def _parse_asin(text, opt)
          return if @@pattern_asin !~ text
          scheme, asincode, type, size = $1, $2, $3 || '', $4 || ''
          asincode.gsub!(/\-/, "")
          asin_url = sprintf("%s%s%s", @asin_url, asincode, @affiliate_path)
          case type
          when /^title/i
            title = get_asin_title(asincode) || "#{scheme}:#{asincode}"
            return sprintf('<a href="%s"%s>%s</a>', asin_url, @a_target_string, title)
          when /^image/i
            size = size.downcase
            size = 'medium' if size.empty?
            prop = get_property(asincode)
            method = 'image_url_' << size
            url = prop.__send__(method)
            if prop and url
              title = prop.product_name || "#{scheme}:#{asincode}"
              return sprintf('<a href="%s"%s><img src="%s" alt="%s" title="%s" class="asin"></a>',
                             asin_url, @a_target_string, url, title, title)
            else
              return sprintf('<a href="%s"%s>%s:%s</a>', asin_url, @a_target_string, scheme, asincode)
            end
          when /^detail/i
            STDERR.puts("detail")
            prop = get_property(asincode) or return
            title = prop.product_name || "#{scheme}:#{asincode}"
            html = ERB.new(@@detail_template).result(binding)
            html = "<p>#{html}</p>" if opt[:in_paragraph]
          else
            return sprintf('<a href="%s"%s>%s</a>', asin_url, @a_target_string, text)
          end
        end

        private

        def get_property(asin)
          ua.asin_search(asin).products[0]
        end

        def get_asin_title(asin)
          return if asin.nil? or asin.empty?
          prop = get_property(asin) or return
          prop.product_name
        end

        def ua
          Amazon::Search::Request.new(@amazon_token, @amazon_affiliate_id, @amazon_locale)
        end
      end
    end
  end
end
