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

=== 5
--- in
><blockquote cite="http://journal.mycom.co.jp/articles/2007/06/07/gears/index.html" title="【ハウツー】"ブラウザ+Gears"でここまでできる! Google GearsのDB機能を使ってみよう (1) Gearsの持つ組み込みデータベース | エンタープライズ | マイコミジャーナル"><
Gearsによるデータベースアクセス方法は、JDBCなどによく似ているため習得するのは容易だ。以下に、そのほとんどを網羅した疑似的なコードを掲載するので参考にしてほしい。
></blockquote><
--- out
<div class="section">
	<blockquote cite="http://journal.mycom.co.jp/articles/2007/06/07/gears/index.html" title="【ハウツー】">
	<p>Gearsによるデータベースアクセス方法は、JDBCなどによく似ているため習得するのは容易だ。以下に、そのほとんどを網羅した疑似的なコードを掲載するので参考にしてほしい。</p>
	<cite><a href="http://journal.mycom.co.jp/articles/2007/06/07/gears/index.html">【ハウツー】</a></cite></blockquote>
</div>
