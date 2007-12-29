require "t/test_helper"
require "text/hatena"

class TextHatenaQuoteTest < Test::Base
  filters %w(.chomp)
  filters :in => 'hatenaize'
  run_equal :out, :in

  def hatenaize(value)
    parser = Text::Hatena.new
    parser.parse(value)
    parser.html
  end
end

__END__
===
--- in
>>
はてな
<<
--- out
<div class="section">
	<blockquote>
		<p>はてな</p>
	</blockquote>
</div>

===
--- in
>http://www.hatena.ne.jp/>
はてな
<<
--- out
<div class="section">
	<blockquote title="http://www.hatena.ne.jp/" cite="http://www.hatena.ne.jp/">
		<p>はてな</p>
		<cite><a href="http://www.hatena.ne.jp/">http://www.hatena.ne.jp/</a></cite>
	</blockquote>
</div>
