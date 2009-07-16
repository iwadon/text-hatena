require File.dirname(__FILE__) + '/test_helper.rb'

require 'test/base'
require 'yaml'

class CovertTest < Test::Base
  filters :proc_filter => ['.to_i', Proc.new{|value| value + 10}]

  def run_tests(spec)
    assert_equal spec.ary, [1,2,'str']
    assert_equal spec.ary_yaml, [1,2,'str'].to_yaml
    assert_equal spec.local_filter, 8
    assert_equal spec.method_chain, '4.3322'
    assert_equal spec.proc_filter, 5
  end

  def local_filter_add_3(value)
    value + 3
  end
end

__END__
===
--- ary eval
[1,2,'str']

--- ary_yaml eval .to_yaml
[1,2,'str']

--- local_filter .to_i local_filter_add_3
5

--- method_chain .to_f .to_s .to_f .to_s
4.3322

--- proc_filter
-5

