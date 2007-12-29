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
=== 1
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

=== 2
--- in
>http://www.hatena.ne.jp/>
はてな
<<
--- out
<div class="section">
	<blockquote title="http://www.hatena.ne.jp/" cite="http://www.hatena.ne.jp/">
		<p>はてな</p>
	<cite><a href="http://www.hatena.ne.jp/">http://www.hatena.ne.jp/</a></cite></blockquote>
</div>

=== 3
--- in
>http://www.hatena.ne.jp/:title>
はてな
<<
--- out
<div class="section">
	<blockquote title="はてな" cite="http://www.hatena.ne.jp/">
		<p>はてな</p>
	<cite><a href="http://www.hatena.ne.jp/">はてな</a></cite></blockquote>
</div>

=== 4
--- in
>http://www.hatena.ne.jp/:title=はてな>
はてな
<<
--- out
<div class="section">
	<blockquote title="はてな" cite="http://www.hatena.ne.jp/">
		<p>はてな</p>
	<cite><a href="http://www.hatena.ne.jp/">はてな</a></cite></blockquote>
</div>
