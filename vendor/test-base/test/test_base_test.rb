require File.dirname(__FILE__) + '/test_helper.rb'

require 'test/base'

class TestBaseTest < Test::Base
  filters %w(.strip)
  filters :input => %w(eval)

  def run_tests(spec)
    assert_match /^description/, spec.description
    assert_equal spec.input, spec.output
  end

  def double(value)
    value * 2
  end

  def triple(value)
    value * 3
  end
end

__END__
=== description1
--- input
'foo'
--- output
foo

=== description2
--- input
'fooo'
--- output
fooo

=== description3
--- input double
'fooo'
--- output
fooofooo

=== description4
--- input double double
'ooo'
--- output triple double
oo

