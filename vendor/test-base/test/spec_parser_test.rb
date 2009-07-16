require File.dirname(__FILE__) + '/test_helper.rb'

require 'test/base/spec_parser'

class Test::Base::SpecParser
# for test
  attr_accessor :source, :blocks
end

class SpecParserTest < Test::Unit::TestCase
  def setup
    @sp = Test::Base::SpecParser.new('')
  end

  def test_normal
    @sp.source = <<-EOF
=== blockname foo
--- input
foo
--- output
foofoo

=== blockname fooo
--- input
fooo
--- output
fooofooo

=== blockname yahoo
--- foo
yahoo
^^
 
--- bar
fooofooo

^^

--- baz

    EOF
    @sp.parse!
    s0, s1, s2 = *@sp.blocks

    assert_equal s0.name, 'blockname foo'
    assert_equal s0.original_values[:input], "foo\n"
    assert_equal s0.block_config[:filters][:input], []
    assert_equal s0.original_values[:output], "foofoo\n"
    assert_equal s0.block_config[:filters][:output], []
    assert_equal s0.block_config[:order], [:input, :output]
    
    assert_equal s1.name, 'blockname fooo'
    assert_equal s1.original_values[:input], "fooo\n"
    assert_equal s1.block_config[:filters][:input], []
    assert_equal s1.original_values[:output], "fooofooo\n"
    assert_equal s1.block_config[:filters][:output], []
    assert_equal s1.block_config[:order], [:input, :output]
    
    assert_equal s2.name, 'blockname yahoo'
    assert_equal s2.original_values[:foo], "yahoo\n^^\n \n"
    assert_equal s2.block_config[:filters][:foo], []
    assert_equal s2.original_values[:bar], "fooofooo\n\n^^\n\n"
    assert_equal s2.block_config[:filters][:bar], []
    assert_equal s2.original_values[:baz], "\n"
    assert_equal s2.block_config[:filters][:baz], []
    assert_equal s2.block_config[:order], [:foo, :bar, :baz]
  end

  def test_filters
    @sp.source = <<-EOF
===
--- input .to_s foo bar
foo
--- output foo -bar baz
foofoo

===
--- input ary .to_yaml inblockt
fooo
--- output 
fooofooo
    EOF
    @sp.parse!
    s0, s1 = *@sp.blocks

    assert_equal s0.original_values[:input], "foo\n"
    assert_equal s0.block_config[:filters][:input], %w(.to_s foo bar)
    assert_equal s0.original_values[:output], "foofoo\n"
    assert_equal s0.block_config[:filters][:output], %w(foo -bar baz)

    assert_equal s1.original_values[:input], "fooo\n"
    assert_equal s1.block_config[:filters][:input], %w(ary .to_yaml inblockt)
    assert_equal s1.original_values[:output], "fooofooo\n"
    assert_equal s1.block_config[:filters][:output], []
  end

  def test_oneline
    @sp.source = <<-EOF
===
--- input: datafoo
--- output: data bar
--- output2: output2

===
--- foo
yahoo
^^
 
--- bar
fooofooo

^^

--- baz





===
--- output foo -bar baz: data bar
--- input .to_s(2) .to_args(*abc, d) foo bar:datafoo

    EOF
    @sp.parse!
    s0, s1, s2 = *@sp.blocks

    assert_equal s0.original_values[:input], "datafoo"
    assert_equal s0.block_config[:filters][:input], []
    assert_equal s0.original_values[:output], "data bar"
    assert_equal s0.block_config[:filters][:output], []
    assert_equal s0.original_values[:output2], "output2"
    assert_equal s0.block_config[:filters][:output2], []
    assert_equal s0.block_config[:order], [:input, :output, :output2]

    assert_equal s1.original_values[:foo], "yahoo\n^^\n \n"
    assert_equal s1.block_config[:filters][:foo], []
    assert_equal s1.original_values[:bar], "fooofooo\n\n^^\n\n"
    assert_equal s1.block_config[:filters][:bar], []
    assert_equal s1.original_values[:baz], "\n\n\n\n"
    assert_equal s1.block_config[:filters][:baz], []
    assert_equal s1.block_config[:order], [:foo, :bar, :baz]

    assert_equal s2.original_values[:input], "datafoo"
    assert_equal s2.block_config[:filters][:input], ['.to_s(2)', '.to_args(*abc, d)', 'foo', 'bar']
    assert_equal s2.original_values[:output], "data bar"
    assert_equal s2.block_config[:filters][:output], %w(foo -bar baz)
    assert_equal s2.block_config[:order], [:output, :input]

  end

  def test_description
    @sp.source = <<-EOF
=== name
desc

=== name2
desc2


=== namedesc

    EOF
    @sp.parse!
    s0, s1, s2 = *(@sp.blocks.map {|b| b.blocknize!(self) })

    assert_equal s0.name, 'name'
    assert_equal s0.description, "desc\n"
    assert_equal s1.name, 'name2'
    assert_equal s1.description, "desc2\n\n"
    assert_equal s2.name, 'namedesc'
    assert_equal s2.description, "namedesc"
  end
end
