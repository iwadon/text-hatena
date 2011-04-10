require "t/test_helper"
require "text/hatena"

class HxNodeTest < Test::Base
  filters %w(.strip)
  run_equal :output, :input

  def hatenafy(text)
    parser = Text::Hatena.new
    parser.parse(text)
    parser.html
  end

  def hatenafy2(text)
    parser = Text::Hatena.new :hrank => 2
    parser.parse(text)
    parser.html
  end
end

__END__

===
--- input hatenafy
*H3
**H4
***H5
--- output
<div class="section">
	<h3><a href="#p1" name="p1"><span class="sanchor">o-</span></a> H3</h3>
	<h4>H4</h4>
	<h5>H5</h5>
</div>

===
--- input hatenafy2
*H2
**H3
***H4
--- output
<div class="section">
	<h2><a href="#p1" name="p1"><span class="sanchor">o-</span></a> H2</h2>
	<h3>H3</h3>
	<h4>H4</h4>
</div>
