require File.dirname(__FILE__) + '/test_helper.rb'

require 'test/base'

class SpecTypeHashTest < Test::Base
  filters %w(.strip)

  def run_tests(spec)
    assert_equal spec[:foo], 'example'
    assert_equal spec[:bar], 'example'
    assert_equal spec[:baz], 'example'
  end
end

__END__
===
--- foo: example
--- bar: example
--- baz: example

===
--- foo: example
--- bar: example
--- baz: example

