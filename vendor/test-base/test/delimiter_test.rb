require File.dirname(__FILE__) + '/test_helper.rb'

require 'test/base'

class DelimitorTest < Test::Base
  delimitors '***', '++++'
  run_equal :input, :output
end

class DelimiterFromFileTest < Test::Base
  spec_file(File.dirname(__FILE__) + '/spec_file_delimitor.txt')
  delimitors ']]]', '[[['
  run_equal :input, :output
end

__END__
*** 
++++ input: foo
++++ output: foo

*** 
++++ input: bar
++++ output: bar

*** 
++++ input
baz
++++ output
baz
