require File.dirname(__FILE__) + '/test_helper.rb'

require 'test/base'

class CallArgsTest < Test::Base
  SPLIT_SEP = //
  run_equal :in, :out
end

__END__
===
--- in eval .to_s(2)
10
--- out : 1010

===
--- in .chomp .split(//, 2)
abc
--- out eval: %w(a bc)

===
--- in .chomp .split(SPLIT_SEP, 2)
abc
--- out eval: %w(a bc)

