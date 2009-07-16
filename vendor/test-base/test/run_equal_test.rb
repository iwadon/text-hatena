require File.dirname(__FILE__) + '/test_helper.rb'

require 'test/base'

class RunEqualTest < Test::Base
  run_equal :input, :output
end

__END__
=== 
--- input: foo
--- output: foo

=== 
--- input: bar
--- output: bar

=== 
--- input:             bar
--- output: bar

=== 
--- input .split:             bar
--- output .split: bar

=== 
--- (input):             bar
--- (output): bar

=== 
--- (input)  .split :             bar
--- (output) .split : bar


