require "erb"
require 'nkf'
require "open-uri"
begin
  require "amazon/aws"
  require "amazon/aws/search"
rescue LoadError
end
require "text/hatena/auto_link/scheme"

module Text
  class Hatena
    class AutoLink
      class ASIN < Scheme
        include ERB::Util

        @@pattern_asin_title = /\[(isbn|asin):([\w\-]{10,16}):title=(.*?)\]/i
        @@pattern_asin = /\[?(isbn|asin):([\w\-]{10,16}):?(image|detail|title)?:?(small|large)?\]?/i
        @@detail_template = <<END
<div class="hatena-asin-detail">
  <%- if (prop.small_image || prop.large_image || prop.medium_image) -%>
  <a href="<%= h(asin_url || url) %>">
    <img src="<%= h((prop.small_image || prop.large_image || prop.medium_image).url) %>" class="hatena-asin-detail-image" alt="<%= h(title) %>" title="<%= h(title) %>"></a>
  <%- else -%>
  <a href="<%= h(asin_url || url) %>"><img src="http://d.hatena.ne.jp/images/hatena_aws.gif" class="hatena-asin-detail-image" alt="<%= h(title) %>" title="<%= h(title) %>"></a>
  <%- end -%>
  <div class="hatena-asin-detail-info">
  <p class="hatena-asin-detail-title"><a href="<%= h(asin_url) %>"><%= h(title) %></a></p>
  <ul>
    <%- if attrs.artists -%>
    <li><span class="hatena-asin-detail-label">\343\202\242\343\203\274\343\203\206\343\202\243\343\202\271\343\203\210:</span>
      <%- attrs.artists.each do |artist| -%>
      <a href="<%= h(@keyword_url) %><%= URI.escape(NKF.nkf('-We', artist)).downcase %>" class="keyword"><%= h(artist) %></a>
      <%- end -%>
    </li>
    <%- end -%>
    <%- if attrs.authors or attrs.author -%>
    <li><span class="hatena-asin-detail-label">\344\275\234\350\200\205:</span>
      <%- (attrs.authors || [attrs.author]).each do |author| -%>
      <a href="<%= h(@keyword_url) %><%= URI.escape(NKF.nkf('-We', author)).downcase %>" class="keyword"><%= h(author) %></a>
      <%- end -%>
    </li>
    <%- end -%>
    <%- if attrs.manufacturer -%>
    <li><span class="hatena-asin-detail-label">\345\207\272\347\211\210\347\244\276/\343\203\241\343\203\274\343\202\253\343\203\274:</span>
    <%- attrs.manufacturer.each do |manufacturer| -%>
      <a href="<%= h(@keyword_url) %><%= URI.escape(NKF.nkf('-We', manufacturer)).downcase %>" class="keyword"><%= h(manufacturer) %></a>
    <%- end -%>
    </li>
    <%- end -%>
    <%- if attrs.publication_date -%>
    <li><span class="hatena-asin-detail-label">\347\231\272\345\243\262\346\227\245:</span><%= h(attrs.publication_date.to_s.gsub(/-/, '/')) %></li>
    <%- end -%>
    <%- if attrs.release_date -%>
    <li><span class="hatena-asin-detail-label">\347\231\272\345\243\262\346\227\245:</span><%= h(attrs.release_date.to_s.gsub(/-/, '/')) %></li>
    <%- end -%>
    <%- if attrs[0].instance_eval('@binding') -%>
    <li><span class="hatena-asin-detail-label">\343\203\241\343\203\207\343\202\243\343\202\242:</span><%= h(attrs[0].instance_eval('@binding')) %></li>
    <%- end -%>
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
          @amazon_token = @option[:amazon_token] || "0VQ4VDB1VMJE2RGYE782"
          @amazon_locale = @option[:amazon_locale] || "jp"
          @amazon_affiliate_id = @option[:amazon_affiliate_id] || "moonrock-22"
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
            url = prop.__send__("#{size}_image").url
            if prop and url
              title = prop.product_name || "#{scheme}:#{asincode}"
              return sprintf('<a href="%s"%s><img src="%s" alt="%s" title="%s" class="asin"></a>',
                             asin_url, @a_target_string, url, title, title)
            else
              return sprintf('<a href="%s"%s>%s:%s</a>', asin_url, @a_target_string, scheme, asincode)
            end
          when /^detail/i
            prop = get_property(asincode) or return
            attrs = prop.item_attributes
            title = attrs.title || "#{scheme}:#{asincode}"
            html = ERB.new(@@detail_template, nil, '-').result(binding)
            html = "<p>#{html}</p>" if opt[:in_paragraph]
          else
            return sprintf('<a href="%s"%s>%s</a>', asin_url, @a_target_string, text)
          end
        end

        private

        def get_property(asin)
          il = ::Amazon::AWS::ItemLookup.new('ASIN', {'ItemId' => asin})
          rg = ::Amazon::AWS::ResponseGroup.new('Large')
          res = ua.search(il, rg)
          res.item_lookup_response.items.item[0]
        end

        def get_asin_title(asin)
          return if asin.nil? or asin.empty?
          prop = get_property(asin) or return
          prop.item_attributes.title
        end

        def ua
          ::Amazon::AWS::Search::Request.new(@amazon_token, @amazon_affiliate_id, @amazon_locale)
        end
      end
    end
  end
end
