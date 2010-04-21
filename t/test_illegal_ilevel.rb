$:.unshift(File.dirname(__FILE__) + "/../vendor/test-base/lib")
require "test/unit"
$:.unshift(File.dirname(__FILE__) + "/../lib")
require "text/hatena"

class IllegalIlevelTest < Test::Unit::TestCase
  def test_s_new
    hatena = Text::Hatena.new
  end
end
