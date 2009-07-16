require File.dirname(__FILE__) + '/test_helper.rb'

require 'test/base'

class FiltersBaseTest < Test::Base
  filters :input => %w(yaml)
  filters :output => %w(eval)
  run_equal :input, :output
end

__END__
===
--- input
- 1
- 2
- 3
--- output
[1,2,3]
