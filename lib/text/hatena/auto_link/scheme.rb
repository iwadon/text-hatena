module Text
  class Hatena
    class AutoLink
      class Scheme
        attr_accessor :patterns

        def initialize(args = {})
          @option = args
          init
        end

        def init
          @a_target = @option[:a_target]
          @a_target_string = @a_target ?
            %Q! target="#{escape_attr(@a_target)}"! :
            ""
        end

        def parse(text)
          text
        end

        def pattern
          /#{patterns.join("|")}/
        end

        def escape_attr(str)
          str.gsub(/\"/, "&quote;")
        end

        def html_encode(text)
          return nil if str.nil? or str.empty?
          text.gsub(/(\W)/) do
            sprintf("%%%02x", $1[0])
          end
        end
      end
    end
  end
end