require File.dirname(__FILE__) + '/test_helper.rb'

require 'test/base'

class RunMatchTest < Test::Base
  filters :pattern => %w(eval), :string => %w(.strip)
  run_match :pattern, :string
end

__END__
=== 
--- string: 12345
--- pattern: /^\d+/

=== 
--- string: foobarbaz
--- pattern: /bar/

