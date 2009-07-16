require File.dirname(__FILE__) + '/test_helper.rb'

require 'test/base'

class LastTest < Test::Base
  filters :exec => %w(eval)
end

__END__
=== 
--- exec
assert true

=== 
--- exec
assert true

=== last
--- LAST
--- exec
assert true

=== over last
--- exec
assert false

