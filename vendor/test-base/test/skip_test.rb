require File.dirname(__FILE__) + '/test_helper.rb'

require 'test/base'

class SkipTest < Test::Base
  filters :exec => %w(eval)
end

__END__
=== no skip
--- exec
assert true

=== skip
--- SKIP
--- exec
assert false

=== no skip
--- exec
assert true

=== skip
--- exec
assert false
--- SKIP

=== skip
--- SKIP
--- exec
assert false

=== no skip
--- exec
assert true

