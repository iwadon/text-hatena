begin
  require "test/base"
rescue LoadError
  require "rubygems"
  require "test/base"
end
module Test
  class Base
    PASSTHROUGH_EXCEPTIONS = []
  end
end
$:.unshift(File.dirname(__FILE__) + "/../lib")
require "text/hatena"
