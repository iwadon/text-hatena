begin
  require "test/base"
rescue LoadError
  require "rubygems"
  require "test/base"
end
$:.unshift(File.dirname(__FILE__) + "/../lib")
require "text/hatena"
