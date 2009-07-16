require File.dirname(__FILE__) + '/test_helper.rb'

require 'test/base'
require 'yaml'

class SpecFileTest < Test::Base
  filters %w(.strip)
  filters :input => %w(eval)

  spec_file(File.dirname(__FILE__) + '/spec_file.txt')

  def run_tests(spec)
    assert_equal spec.input, spec.output
  end

  def double(value)
    value * 2
  end

  def triple(value)
    value * 3
  end
end
