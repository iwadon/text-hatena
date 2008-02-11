require "t/test_helper"
require "text/hatena"

class FootnoteInListTest < Test::Base
  filters %w(.chomp)
  filters :in => 'hatenaize'
  run_equal :out, :in

  def hatenaize(value)
    parser = Text::Hatena.new({})
    parser.parse(value)
    parser.html
  end
end

__END__

===
--- in
普通の((脚注))
--- out
<div class="section">
	<p>普通の<span class="footnote"><a href="#f1" title="脚注" name="fn1">*1</a></span></p>
</div>
<div class="footnote">
	<p class="footnote"><a href="#fn1" name="f1">*1</a>: 脚注</p>
</div>

===
--- in
-リストの中の((脚注))
--- out
<div class="section">
	<ul>
		<li>リストの中の<span class="footnote"><a href="#f1" title="脚注" name="fn1">*1</a></span></li>
	</ul>
</div>
<div class="footnote">
	<p class="footnote"><a href="#fn1" name="f1">*1</a>: 脚注</p>
</div>

===
--- in
+リストの中の((脚注))
--- out
<div class="section">
	<ol>
		<li>リストの中の<span class="footnote"><a href="#f1" title="脚注" name="fn1">*1</a></span></li>
	</ol>
</div>
<div class="footnote">
	<p class="footnote"><a href="#fn1" name="f1">*1</a>: 脚注</p>
</div>
