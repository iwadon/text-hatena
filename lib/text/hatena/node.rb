module Text
  class Hatena
    class Node
      def initialize(args = {})
        @context = args[:context]
        @ilevel = args[:ilevel]
        @html = ""
        init
      end

      def init
        @pattern = ""
      end

      def parse
        raise NotImplementedError
      end

      def html
        @html
      end

      def pattern
        @pattern
      end

      def context(value = nil)
        @context = value unless value.nil?
        @context
      end
    end
  end
end
