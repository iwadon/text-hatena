require 'test/base/base'
require 'test/base/block'
require 'strscan'

class Test::Base::SpecParser
  DEFAULT_DELIMITERS = ['===', '---']

  def initialize(source, delimiters = nil)
    @source = source
    @delimiters = delimiters || DEFAULT_DELIMITERS
  end
  attr_accessor :delimiters

  def each_block
    parse!
    @blocks.each{|block| yield block}
  end

  def parse!
    @blocks = parse(@source) unless @blocks
  end

  def parse(src)
    blocks = []
    s = StringScanner.new src
    delim_main = '^' + Regexp::escape(delimiters.first)
    delim_sub = '^' + Regexp::escape(delimiters.last)
    while s.scan(/[\r\n.]*?#{delim_main}[ ]*(.*?)\r?\n/) # === description
      block = Test::Base::Block.new
      block.name = s[1] || ''

      while description = s.scan(/(?!(#{delim_sub})|(#{delim_main}))(.*)\r?\n/)
        unless (s.match?(/(#{delim_main})|(#{delim_sub})/) && description.match(/\s+/)) || s.eos?
          block.description ||= ''
          block.description << description 
        end
      end

      while s.scan(/#{delim_sub}[ ]*\(?(\w+)\)?([^:]*?)[ ]*(:[ ]*(.*))?\r?\n/) # --- input filter: value
        name = s[1].to_sym
        filters = s[2].scan(%r{(?:[^\s]+?(?:\([^)]*\)))|(?:[^\s]+)}) # filter(a, *b) filterb .to_s(8)
        if s[4] # oneline's value (ex] --- input: foo )
          value = s[4]
        else
          value = ''
          while match = s.scan(/(?!(#{delim_sub})|(#{delim_main}))(.*)\r?\n/)
            value << match unless (s.match?(/#{delim_main}/) && match.match(/\s+/))
          end
          value << s.scan(/.*/m).to_s unless s.match?(/.*(#{delim_sub})|(#{delim_main})/m) # if last block
        end
        block.append_block(name, value, filters)
        # TODO 現状だと最初にチェックしたフラグになる。perl の方の挙動を調べる。
        case name
        when :SKIP
          flag = :SKIP
        when :LAST
          flag = :LAST
        when :ONLY
          flag = :ONLY
        end unless flag
      end

      blocks << block unless flag == :SKIP
      case flag
      when :SKIP
        flag = nil
      when :ONLY
        return [block]
      when :LAST
        break
      end
    end
    blocks
  end
end
