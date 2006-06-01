module Text
  class Hatena
    class AutoLink
      VERSION = "0.06"
      SCHEMES = {
=begin
        "question" => "text/hatena/auto_link/hatena_question",
        "amazon" => "text/hatena/auto_link/hatena_question",
        "google" => "text/hatena/auto_link/google",
        "mailto" => "text/hatena/auto_link/mailto",
        "search" => "text/hatena/auto_link/hatena_search",
        "graph" => "text/hatena/auto_link/hatena_graph",
        "https" => "text/hatena/auto_link/http",
        "asin" => "text/hatena/auto_link/asin",
=end
        "http" => "Text::Hatena::AutoLink::HTTP",
=begin
        "idea" => "text/hatena/auto_link/hatena_idea",
        "isbn" => "text/hatena/auto_link/asin",
        "ean" => "text/hatena/auto_link/ean",
=end
        "ftp" => "Text::Hatena::AutoLink::FTP",
=begin
        "jan" => "text/hatena/auto_link/ean",
        "map" => "text/hatena/auto_link/hatena_map",
        "tex" => "text/hatena/auto_link/tex",
        "id" => "text/hatena/auto_link/hatena_id",
        "a" => "text/hatena/auto_link/hatena_antenna",
        "b" => "text/hatena/auto_link/hatena_bookmark",
        "d" => "text/hatena/auto_link/hatena_diary",
        "f" => "text/hatena/auto_link/hatena_fotolife",
        "g" => "text/hatena/auto_link/hatena_group",
        "i" => "text/hatena/auto_link/hatena_idea",
        "q" => "text/hatena/auto_link/hatena_question",
        "r" => "text/hatena/auto_link/hatena_rss",
=end
        "]" => "Text::Hatena::AutoLink::Unbracket",
      }

      def initialize(args = {})
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
          option = @scheme_option[scheme] || {}
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
          text = $1
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
