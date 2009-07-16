require 'test/unit'
$LOAD_PATH << File.dirname(__FILE__) + '/../lib'
require 'test/base'

Test::Unit::Util::BacktraceFilter.module_eval do
  module_function :filter_backtrace
end

# for testing
module Test
  class Base
    module Util
      module BacktraceFilter
        def filter_backtrace(backtrace, prefix=nil)
          Test::Unit::Util::BacktraceFilter.filter_backtrace(backtrace, prefix)
        end
      end
    end
  end
end
