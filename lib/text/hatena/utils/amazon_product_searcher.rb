require 'net/http'
require 'rubygems' if RUBY_VERSION < "1.9.0"
require 'nokogiri'

module Text
  class Hatena
    class AmazonProductSearcher
      ENDPOINTS = {
        "ja" => "http://rpaproxy.tdiary.org/rpaproxy/jp/"
      }

      class Image
        attr_reader :url, :width, :height

        def initialize(e)
          @url = e.css('URL').text
          @width = e.css('Width').text.to_i
          @height = e.css('Height').text.to_i
        end
      end

      class Item
        attr_reader :item_attributes

        def initialize(doc)
          @doc = doc
        end

        def artist
          artists[0]
        end

        def artists
          @doc.css('Artist').map do |e| e.text end
        end

        def author
          @doc.css('Author').text
        end

        def authors
          @doc.css('Author').map do |e| e.text end
        end

        def binding
          @binding ||= @doc.css('Binding').text
        end

        def manufacturer
          @doc.css('Manufacturer').text
        end

        def large_image
          Image.new(@doc.css('LargeImage')[0])
        end

        def medium_image
          Image.new(@doc.css('MediumImage')[0])
        end

        def publication_date
          @publication_date ||= @doc.css('PublicationDate').text
        end

        def release_date
          @release_date ||= @doc.css('ReleaseDate').text
        end

        def small_image
          Image.new(@doc.css('SmallImage')[0])
        end

        def title
          @title ||= @doc.css('ItemAttributes Title').text
        end
      end

      def initialize(args = {})
        @access_key = args['access_key'] || args[:access_key] || "0VQ4VDB1VMJE2RGYE782"
        @associate_tag = args['associate_tag'] || args[:associate_tag] || "moonrock-22"
      end

      # This method is based on http://github.com/tdiary/tdiary-core/misc/plugin/amazon.rb
      def lookup(asin)
        xml = nil
        begin
          File.open("#{asin}.xml") do |f|
            f.flock(File::LOCK_SH)
            xml = f.read
          end
        rescue Errno::ENOENT
          url = ENDPOINTS["ja"].dup
          url << "?Service=AWSECommerceService"
          url << "&AWSAccessKeyId=#{@access_key}"
          url << "&AssociateTag=#{@associate_tag}"
          url << "&Operation=ItemLookup"
          url << "&ItemId=#{asin}"
          url << "&IdType=ASIN"        # ASIN, ISBN, EAN
          url << "&ResponseGroup=Medium"
          url << "&Version=2011-08-01"
          xml = fetch(url)
          File.open("#{asin}.xml", "w") do |f|
            f.flock(File::LOCK_EX)
            f.write(xml)
          end
        end
        doc = Nokogiri::XML(xml)
        Item.new(doc.css('Items Item')[0])
      end

      # This method is based on http://github.com/tdiary/tdiary-core/misc/plugin/amazon.rb
      def fetch(url, limit = 10)
        raise ArgumentError, "HTTP Redirect too deep" if limit.zero?
        res = Net::HTTP.get_response(URI.parse(url))
        case res
        when Net::HTTPSuccess
          res.body
        when Net::HTTPRedirection
          fetch(res['location'], limit - 1)
        else
          raise ArgumentError, res.error!
        end
      end
    end
  end
end
