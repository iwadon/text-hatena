require File.dirname(__FILE__) + '/test_helper.rb'

require 'test/base'

class RunEvalTest < Test::Base
  filters :run_eval => %w(eval)
  CONSTANT_TEST = 'example'
end

__END__
===
--- run_eval
assert true

=== eval binding context
--- run_eval
assert_equal CONSTANT_TEST, 'example'

