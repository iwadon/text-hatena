module Text
  class Hatena
    class AutoLink
      VERSION = "0.06"
      SCHEMES = {
        "question" => "Text::Hatena::AutoLink::HatenaQuestion",
        "amazon" => "Text::Hatena::AutoLink::HatenaQuestion",
        "google" => "Text::Hatena::AutoLink::Google",
        "mailto" => "Text::Hatena::AutoLink::Mailto",
        "search" => "Text::Hatena::AutoLink::HatenaSearch",
        "graph" => "Text::Hatena::AutoLink::HatenaGraph",
        "https" => "Text::Hatena::AutoLink::HTTP",
        "asin" => "Text::Hatena::AutoLink::ASIN",
        "http" => "Text::Hatena::AutoLink::HTTP",
        "idea" => "Text::Hatena::AutoLink::HatenaIdea",
        "isbn" => "Text::hatena::AutoLink::ASIN",
        "ean" => "Text::Hatena::AutoLink::EAN",
        "ftp" => "Text::Hatena::AutoLink::FTP",
        "jan" => "Text::Hatena::AutoLink::EAN",
        "map" => "Text::Hatena::AutoLink::HatenaMap",
        "tex" => "Text::Hatena::AutoLink::Tex",
        "id" => "Text::Hatena::AutoLink::HatenaID",
        "a" => "Text::Hatena::AutoLink::HatenaAntenna",
        "b" => "Text::Hatena::AutoLink::HatenaBookmark",
        "d" => "Text::Hatena::AutoLink::HatenaDiary",
        "f" => "Text::Hatena::AutoLink::HatenaFotolife",
        "g" => "Text::Hatena::AutoLink::HatenaGroup",
        "i" => "Text::Hatena::AutoLink::HatenaIdea",
        "q" => "Text::Hatena::AutoLink::HatenaQuestion",
        "r" => "Text::Hatena::AutoLink::HatenaRSS",
        "]" => "Text::Hatena::AutoLink::Unbracket",
      }

      def initialize(args = nil)
        args ||= {}
        @a_target = args[:a_target]
        @scheme_option = args[:scheme_option] || {}
        @invalid_scheme = args[:invalid_scheme] || []
        init
      end

      def init
        pattern = []
        invalid = Hash.new(false)
        @invalid_scheme.each do |is|
          invalid[is] = true
        end
        @parser = {}
        known = Hash.new(false)
        SCHEMES.each_key do |scheme|
          next if invalid[scheme]
          p = SCHEMES[scheme]
          require underscore(p)
          option = @scheme_option[scheme.to_s] || @scheme_option[scheme.intern] || {}
          unless option.key?(:a_target)
            option[:a_target] = @a_target
          end
          @parser[scheme] = get_class(p).new(option)
          next if known[p]
          known[p] = true
          pattern << @parser[scheme].pattern
        end
        @pattern = /#{pattern.join("|")}/
      end

      def parse(text, opt = {})
        schemes = @parser.keys.sort do |a, b|
          if b == "]"
            1
          else
            b.size <=> a.size
          end
        end
        text.gsub(@pattern) do
          text = $&
          parser = nil
          schemes.each do |sc|
            if /^\w+$/ =~ sc and /^\[?#{sc}:/i =~ text
              parser = @parser[sc]
            elsif /^\[?#{Regexp.quote(sc)}/i =~ text
              parser = @parser[sc]
            end
            break if parser
          end
          parser.parse(text, opt) # ??? parser.nil?
        end
      end

      private

      def underscore(str)
        str.gsub(/([a-z])([A-Z])/, '\1_\2').gsub(/::/, "/").downcase
      end

      def get_class(str)
        str.split(/::/).inject(Object) do |klass, s|
          klass.const_get(s)
        end
      end
    end
  end
end
