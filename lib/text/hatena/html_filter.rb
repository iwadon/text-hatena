require "text/hatena/utils/htmlsplit"

module Text
  class Hatena
    class HTMLFilter
      def initialize(args = {})
        @context = args[:context]
        @html =  "" 
        @in_paragraph = false
        @in_anchor = false
        @in_superpre = false
        @additional_allowtag = args[:allowtag] || {}
        @in_quote = nil
        init
      end

      def init
        @parser = HTMLSplit
#=begin
        @allowtag = Regexp.union(/^(a|abbr|acronym|address|b|base|basefont|big|blockquote|br|col|em|caption|center|cite|code|div|dd|del|dfn|dl|dt|fieldset|font|form|hatena|h\d|hr|i|img|input|ins|kbd|label|legend|li|meta|ol|optgroup|option|p|pre|q|rb|rp|rt|ruby|s|samp|select|small|span|strike|strong|sub|sup|table|tbody|td|textarea|tfoot|th|thead|tr|tt|u|ul|var)$/, /^#{@additional_allowtag.keys.join('|')}$/)
        @allallowattr = /^(accesskey|align|alt|background|bgcolor|border|cite|class|color|datetime|height|id|size|style|title|type|valign|width)$/
        @allowattr = {
          :a => 'href|name|target',
          :base => 'href|target',
          :basefont => 'face',
          :blockquote => 'cite',
          :br => 'clear',
          :col => 'span',
          :font => 'face',
          :form => 'action|method|target|enctype',
          :hatena => '.+',
          :img => 'src',
          :input => 'type|name|value|tabindex|checked|src',
          :label => 'for',
          :li => 'value',
          :meta => 'name|content',
          :ol => 'start',
          :optgroup => 'label',
          :option => 'value',
          :select => 'name|accesskey|tabindex',
          :table => 'cellpadding|cellspacing',
          :td => 'rowspan|colspan|nowrap',
          :th => 'rowspan|colspan|nowrap',
          :textarea => 'name|cols|rows',
        }.merge(@additional_allowtag)
#=end
      end

      def parse(html)
        scanner = @parser.new(html)
        scanner.document.each do |tag|
          text = tag.to_s
          case tag
          when HTMLSplit::StartTag
            starthandler(tag.name, tag.attr, text)
          when HTMLSplit::EmptyElementTag
            emptyelemtaghandler(tag.name, tag.attr, text)
          when HTMLSplit::EndTag
            endhandler(tag.name, text)
          when HTMLSplit::Comment
            commenthandler(text)
          when HTMLSplit::CharacterData
            texthandler(text)
          else
            texthandler(sanitize(text))
          end
        end
      end

      def texthandler(text)
        text = @context.texthandler.call(text, @context, self)
        @html << text
      end

      def starthandler(tagname, attr, text)
        attr ||= {}
        if tagname == "p"
          @in_paragraph = true
        elsif tagname == "a"
          @in_anchor = true
        elsif tagname == "pre" and attr["class"] == "hatena-super-pre"
          @in_superpre = true
        elsif tagname == "blockquote" or tagname == "q"
          @in_quote = attr.dup
        end
#        @html << text
        if @allowtag =~ tagname
          @html << "<#{tagname}"
          unless attr.nil?
            attr.each do |p, v|
              v = p if v == true
              if @allallowattr =~ p
              elsif @allowattr[tagname.intern] and /^#{@allowattr[tagname.intern]}$/i =~ p
              else
                next
              end
              if /^(src|href|cite)$/i =~ p
                v = sanitize_url(v)
              else
                v = sanitize(v)
              end
              @html << %Q| #{p}="#{v}"|
            end
          end
          @html << ">"
        else
          @html << sanitize(text)
        end
      end

      def endhandler(tagname, text)
        if tagname == 'p'
          @in_paragraph = false
        elsif tagname == 'a'
          @in_anchor = false
        elsif tagname == 'pre' and @in_superpre
          @in_superpre = false
        elsif tagname == 'blockquote' or tagname == "q"
          attr = @in_quote || {}
          @in_quote = nil
          cite = attr["cite"].to_s
          unless cite.empty?
            title = attr["title"].to_s
            title = "*" if title.empty?
            @html << "<cite><a href=\"#{sanitize_url(cite)}\">#{sanitize(title)}</a></cite>"
          end
        end
        if @allowtag =~ tagname
          @html << "</#{tagname}>"
        else
          @html << sanitize(text)
        end
      end

      def commenthandler(text)
        @html << "<!--#{text}-->"
      end

      def emptyelemtaghandler(tagname, attr, text)
#        @html << text
#=begin
        if tagname =~ @allowtag
          @html << "<#{tagname}"
          unless attr.nil?
            attr.each do |p, v|
              if p =~ @allallowattr
              elsif @allowattr[tagname.to_sym] && /^#{@allowattr[tagname.to_sym]}$/i =~ p
              else
                next
              end
              v = sanitize(v)
              @html << %Q| #{p}="#{v}"|
            end
          end
          @html << " />"
        else
          @html << sanitize(text)
        end
#=end
      end

#=begin
      def sanitize(str)
        return str if str.empty?
        str.gsub!(/&(?![\#a-zA-Z0-9_]{2,6};)/, "&amp;")
        str.gsub!(/\</, "\&lt\;")
        str.gsub!(/\>/, "\&gt\;")
#        str.gsub!(/\"/, "&quot;")
        str.gsub!(/\'/, "&#39;/")
        str.gsub!(/\\/, "\&#92\;")
        return str
      end

      def sanitize_url(url)
        return if url.empty?
        url.gsub!(/^\s+/, "")
        return if url =~ /^(\&|about|\:)/
        if url =~ /^([A-Za-z]+:)/
          scheme = $1
          return unless scheme =~ /^(http|ftp|https|mailto|rtsp|mms):/i
        elsif url =~ /^(\.|\/|#)/
        else
          url = "./#{url}"
        end
        url.gsub!(/["'<>]/, "")
        return url
      end
#=end

      def html
        @html
      end

      def in_paragraph
        @in_paragraph
      end

      def in_anchor
        @in_anchor
      end

      def in_superpre
        @in_superpre
      end
    end
  end
end
