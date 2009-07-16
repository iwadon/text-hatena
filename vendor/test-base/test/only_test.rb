require File.dirname(__FILE__) + '/test_helper.rb'

require 'test/base'

class LastTest < Test::Base
  filters :exec => %w(eval)
end

__END__
=== no run
--- exec
assert false

=== 
--- ONLY
--- exec
assert true

=== no run
--- exec
assert false

=== no run
--- exec
assert false

