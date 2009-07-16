require File.dirname(__FILE__) + '/test_helper.rb'
require 'test/base/block'

class Test::Base::Block
  public :fix_filter, :str2method_args
end

class BlockTest < Test::Unit::TestCase
  def setup
    @block = Test::Base::Block.new
  end

  def test_blocknize
    assert_kind_of Hash, @block.block_config
    @block.block_config[:filters] = {
      :foo => %w(.strip),
      :bar => %w(eval .strip -eval),
      :baz => %w(eval .strip),
    }
    @block.original_values[:foo] = ' yahoo '
    @block.original_values[:bar] = ' yahoo bar '
    @block.original_values[:baz] = '"string  "'
    @block.block_config[:order] = [:bar, :foo, :baz]
    @block.name = 'testblock'
    assert !@block.empty?
    assert @block.blocknize!(self)
    assert @block[:name], @block.name
    assert @block[:description], @block.description
    assert_equal @block[:foo], @block.foo
    assert_equal @block[:bar], @block.bar
    assert_equal @block[:baz], @block.baz
    assert_equal @block[:baz], 'string'
  end

  def test_append_block
    @block.append_block(:bar, ' yahoo bar ', %w(eval .strip -eval))
    @block.append_block(:foo, ' yahoo ', %w(.strip))
    @block.append_block(:baz, '"string"  ', %w(eval .strip))
    @block.append_block(:filter_proc, '"string"  ', ['eval', Proc.new{|i| i.reverse}])
    @block.name = 'testblock'
    assert @block.blocknize!(self)
    assert @block[:name], @block.name
    assert @block[:description], @block.description
    assert_equal @block[:foo], @block.foo
    assert_equal @block[:bar], @block.bar
    assert_equal @block[:baz], @block.baz
    assert_equal @block[:baz], 'string'
    assert_equal @block[:filter_proc], @block.filter_proc
    assert_equal @block[:filter_proc], 'gnirts'
  end

  def test_fix_filter
    assert_equal [], @block.fix_filter(%w[foo bar -bar -foo])
    assert_equal %w[foo foo], @block.fix_filter(%w[foo bar -bar -baz foo])
  end

  def test_str2method_args
    assert_equal @block.str2method_args('.to_i(8)'), ['.to_i', '8']
    assert_equal @block.str2method_args('.to_i'), ['.to_i', nil]
    assert_equal @block.str2method_args('.to_i()'), ['.to_i', nil]
    assert_equal @block.str2method_args('.to_i(8, foo, bar)'), ['.to_i', '8, foo, bar']
    assert_equal @block.str2method_args('.to_i(8, foo,*bar)'), ['.to_i', '8, foo,*bar']
    assert_equal @block.str2method_args('to(8, foo,*bar)'), ['to', '8, foo,*bar']
  end
end
