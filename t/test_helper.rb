$:.unshift(File.dirname(__FILE__) + "/../vendor/test-base/lib")
require "test/base"
#module Test
#  class Base
#    PASSTHROUGH_EXCEPTIONS = []
#  end
#end
$:.unshift(File.dirname(__FILE__) + "/../lib")
require "text/hatena"
