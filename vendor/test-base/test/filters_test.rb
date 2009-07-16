require File.dirname(__FILE__) + '/test_helper.rb'

require 'test/base/filters'

class FiltersTest < Test::Unit::TestCase
  include Test::Base::Filters

  def test_eval
    assert_equal eval('"str"'), 'str'
    foo = 'example'
    assert_equal eval('foo', binding), foo
  end

  def test_eval_all
    foo = 'example'
    str = <<-EOF
      puts foo
      warn 'bar'
      'baz'
    EOF
    assert_equal eval_all(str, binding), ['baz', "example\n", "bar\n"]
    foo = 'example'
    str = <<-EOF
      puts foo
      raise 'errorTestFoo'
      warn 'bar'
      'baz'
    EOF
    exception, out, err = eval_all(str, binding)
    assert_equal out, "example\n"
    assert_equal err, ''
    assert_match /errorTestFoo/, exception.message
    assert_equal exception.class, RuntimeError
  end

  def test_eval_stdout
    assert_equal eval_stdout('puts "aaa\nbbb"; "foobar"'), "aaa\nbbb\n"
    assert_equal eval_stdout('puts "aaa\nbbb"'), "aaa\nbbb\n"
    foo = 'example'
    assert_equal eval_stdout('puts foo', binding), foo + "\n"
  end

  def test_eval_stderr
    assert_equal eval_stderr('warn "aaa\nbbb"; "foobar"'), "aaa\nbbb\n"
    assert_equal eval_stderr('warn "aaa\nbbb"'), "aaa\nbbb\n"
    foo = 'example'
    assert_equal eval_stderr('warn foo', binding), foo + "\n"
  end

  def test_yaml
    assert_equal yaml("- a\n- b\n"), ['a', 'b']
  end

  def test_erb
    assert_equal erb('<%= "a" * 3 %>'), 'aaa'
    foo = 'bar'
    assert_equal erb('<%= foo %>baz', binding), 'barbaz'
  end

end
