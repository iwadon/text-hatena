$:.unshift(File.dirname(__FILE__) + "/../vendor/test-base/lib")
require "test/unit"
$:.unshift(File.dirname(__FILE__) + "/../lib")
require "text/hatena"

class IllegalIlevelTest < Test::Unit::TestCase
  def test_s_new
    hatena = Text::Hatena.new
    assert_equal(0, hatena.instance_eval("@ilevel"))
    hatena = Text::Hatena.new({:ilevel => 1})
    assert_equal(1, hatena.instance_eval("@ilevel"))
    hatena = Text::Hatena.new({:ilevel => nil})
    assert_equal(0, hatena.instance_eval("@ilevel"))
  end
end
