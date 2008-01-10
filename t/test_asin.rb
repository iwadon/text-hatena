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
    <img src="http://ecx.images-amazon.com/images/I/01FVT6YYFTL.jpg" class="hatena-asin-detail-image" alt="「へんな会社」のつくり方 (NT2X)" title="「へんな会社」のつくり方 (NT2X)"></a>
  <div class="hatena-asin-detail-info">
  <p class="hatena-asin-detail-title"><a href="http://d.hatena.ne.jp/asin/4798110523">「へんな会社」のつくり方 (NT2X)</a></p>
  <ul>
    
    <li><span class="hatena-asin-detail-label">作者:</span><a href="http://d.hatena.ne.jp/keyword/近藤 淳也" class="keyword">近藤 淳也</a></li>
    <li><span class="hatena-asin-detail-label">出版社/メーカー:</span>
    <a href="http://d.hatena.ne.jp/keyword/翔泳社" class="keyword">
      翔泳社
    </a>
    </li>
    <li><span class="hatena-asin-detail-label">発売日:</span>2006/02/13</li>
    <li><span class="hatena-asin-detail-label">メディア:</span>単行本</li>
  </ul>
</div>
<div class="hatena-asin-detail-foot"></div>
</div>
</p></p>
</div>
