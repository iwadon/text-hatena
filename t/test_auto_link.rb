require "test/unit"
$:.unshift(File.dirname(__FILE__) + '/../lib')
require "text/hatena"

class AutoLinkTest < Test::Unit::TestCase
  def hatenaize(value)
    parser = Text::Hatena.new
    parser.parse(value)
    parser.html
  end

  def test_http
    assert_equal(<<EOH.chomp, hatenaize("http://localhost/a(b)c.html"))
<div class="section">
	<p><a href="http://localhost/a(b)c.html">http://localhost/a(b)c.html</a></p>
</div>
EOH
  end
end
