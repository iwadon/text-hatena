require File.dirname(__FILE__) + '/test_helper.rb'

require 'test/base'

module OriginalAssertionMethod
  def assert_double(s, r)
    assert_equal (s.to_i * 2), r.to_i
  end
end

class Test::Base
  include OriginalAssertionMethod
end

class RunOriginalAssertionTest < Test::Base
  run_double :in, :out
end

__END__
=== 
--- in: 1
--- out: 2

=== 
--- in: 3
--- out: 6

=== 
--- in: 5
--- out: 10

