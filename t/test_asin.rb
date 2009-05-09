require "t/test_helper"
require "text/hatena"

class AsinTest < Test::Base
  filters %w(.chomp)
  filters :input => 'hatenaize'
  run_equal :output, :input

  def hatenaize(value)
    parser = Text::Hatena.new
    parser.parse(value)
    parser.html
  end
end

__END__

===
--- input
asin:4798110523:detail
--- output
<div class="section">
	<p><p><div class="hatena-asin-detail">
  <a href="http://d.hatena.ne.jp/asin/4798110523">
    <img src="http://ecx.images-amazon.com/images/I/51CEFZGYJVL._SL75_.jpg" class="hatena-asin-detail-image" alt="「へんな会社」のつくり方 (NT2X)" title="「へんな会社」のつくり方 (NT2X)"></a>
  <div class="hatena-asin-detail-info">
  <p class="hatena-asin-detail-title"><a href="http://d.hatena.ne.jp/asin/4798110523">「へんな会社」のつくり方 (NT2X)</a></p>
  <ul>
    <li><span class="hatena-asin-detail-label">作者:</span>
      <a href="http://d.hatena.ne.jp/keyword/%b6%e1%c6%a3%20%bd%df%cc%e9" class="keyword">近藤 淳也</a>
    </li>
    <li><span class="hatena-asin-detail-label">出版社/メーカー:</span>
      <a href="http://d.hatena.ne.jp/keyword/%e6%c6%b1%cb%bc%d2" class="keyword">翔泳社</a>
    </li>
    <li><span class="hatena-asin-detail-label">発売日:</span>2006/02/13</li>
    <li><span class="hatena-asin-detail-label">メディア:</span>単行本</li>
  </ul>
</div>
<div class="hatena-asin-detail-foot"></div>
</div>
</p></p>
</div>

===
--- input
asin:B00260G73Q:detail
--- output
<div class="section">
	<p><p><div class="hatena-asin-detail">
  <a href="http://d.hatena.ne.jp/asin/B00260G73Q"><img src="http://d.hatena.ne.jp/images/hatena_aws.gif" class="hatena-asin-detail-image" alt="たのしいカトリーヌ" title="たのしいカトリーヌ"></a>
  <div class="hatena-asin-detail-info">
  <p class="hatena-asin-detail-title"><a href="http://d.hatena.ne.jp/asin/B00260G73Q">たのしいカトリーヌ</a></p>
  <ul>
    <li><span class="hatena-asin-detail-label">出版社/メーカー:</span>
      <a href="http://d.hatena.ne.jp/keyword/%bc%ab%c5%be%bc%d6%c1%cf%b6%c8" class="keyword">自転車創業</a>
    </li>
    <li><span class="hatena-asin-detail-label">発売日:</span>2009/05/04</li>
    <li><span class="hatena-asin-detail-label">メディア:</span>CD-ROM</li>
  </ul>
</div>
<div class="hatena-asin-detail-foot"></div>
</div>
</p></p>
</div>
