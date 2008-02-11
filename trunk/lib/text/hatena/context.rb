require "text/hatena/auto_link"

module Text
  class Hatena
    class Context
      def initialize(args = {})
        @text = args[:text]
        @baseuri = args[:baseuri]
        @permalink = args[:permalink]
        @invalidnode = args[:invalidnode]
        @sectionanchor = args[:sectionanchor]
        @autolink_option = args[:autolink_option]
        @texthandler = args[:texthandler]
        @htmllines = []
        @html = ""
        @footnotes = []
        @sectioncount = 0
        @syntaxrefs = []
        @noparagraph = false
        init
      end

      def init
        @text.gsub!(/\r/, "")
        @lines = @text.split(/\n/)
        @index = -1
      end

      def hasnext
        not @lines[@index + 1].nil?
      end

      def nextline
        @lines[@index + 1]
      end

      def shiftline
        @lines[@index += 1]
      end

      def currentline
        @lines[@index]
      end

      def html
        @htmllines.join("\n")
      end

      def htmllines(arg = nil)
        @htmllines.push(arg) unless arg.nil?
        @htmllines
      end

      def lasthtmlline
        @htmllines[-1]
      end

      def footnotes(arg = nil)
        @footnotes.push(arg) unless arg.nil?
        @footnotes
      end

      def syntaxrefs(arg = nil)
        @syntaxrefs.push(arg) unless arg.nil?
        @syntaxrefs
      end

      def syntaxpattern(arg = nil)
        @syntaxpattern.push(arg) unless arg.nil?
        @syntaxpattern
      end

      def noparagraph(*args)
        @noparagraph = args[0] unless args.empty?
        @noparagraph
      end

      def autolink(*args)
        @autolink = args[0] unless args.empty?
        @autolink ||= AutoLink.new(@autolink_option)
        @autolink
      end

      def sectioncount
        @sectioncount
      end

      def incrementsection
        @sectioncount += 1
      end

      def baseuri
        @baseuri
      end

      def permalink
        @permalink
      end

      def invalidnode
        @invalidnode
      end

      def sectionanchor
        @sectionanchor
      end

      def texthandler
        @texthandler
      end
    end
  end
end
