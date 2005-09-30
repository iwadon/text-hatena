require "text/hatena/pre_node"

module Text
  class Hatena
    class SuperpreNode < PreNode
      def init
        @pattern = /^>\|\|$/
        @endpattern = /^\|\|<$/
        @startstring = "<pre>"
        @endstring = "</pre>"
      end
    end
  end
end
