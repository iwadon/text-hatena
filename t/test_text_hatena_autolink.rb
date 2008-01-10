# -*- mode: ruby; coding: utf-8 -*-
require "t/test_helper"
require "text/hatena"
require "text/hatena/auto_link"

class TextHatenaAutoLinkTest < Test::Base
  filters %w(.strip)
  run_equal :out, :in

  def setup
    @options = {}
  end

  def hatenaize(value)
    parser = Text::Hatena.new({ :baseuri => 'http://d.hatena.ne.jp/jkondo',
                                :permalink => 'http://d.hatena.ne.jp/jkondo/20050906',
                                :ilevel => 0,
                                :ivalidnode => [],
                                :sectionanchor => 'sa' }.merge(@options))
    parser.parse(value)
    parser.html
  end

  def do_auto_link(value)
    parser = Text::Hatena::AutoLink.new(@options)
    parser.parse(value)
  end

  def a_target_blank(value)
    @options[:a_target] = '_blank'
    value
  end

  def scheme_option(value)
    @options[:scheme_option] = {:id => {:a_target => nil}}
    value
  end

  def autolink_option(value)
    @options[:autolink_option] = {
      :a_target => '_top',
      :scheme_option => {
        :id => {
          :a_target => '_blank',
        }
      }
    }
    value
  end

  def affiliate_id(value)
    @options[:scheme_option] = {
      :isbn => {
        :amazon_affiliate_id => 'staffdiaryrei-22',
      }
    }
    value
  end
end

__END__

=== 03_autolink_http.t 1
--- in do_auto_link
This is our site. http://www.hatena.ne.jp/
--- out
This is our site. <a href="http://www.hatena.ne.jp/">http://www.hatena.ne.jp/</a>

=== 03_autolink_http.t 2
--- in a_target_blank do_auto_link
This is our site. http://www.hatena.ne.jp/
--- out
This is our site. <a href="http://www.hatena.ne.jp/" target="_blank">http://www.hatena.ne.jp/</a>

=== 03_autolink_http.t 3
--- in do_auto_link
[http://www.hatena.ne.jp/images/top/h1.gif:image]
--- out
<a href="http://www.hatena.ne.jp/images/top/h1.gif"><img src="http://www.hatena.ne.jp/images/top/h1.gif" alt="http://www.hatena.ne.jp/images/top/h1.gif" class="hatena-http-image"></a>

=== 03_autolink_http.t 4
--- in a_target_blank do_auto_link
[http://www.hatena.ne.jp/images/top/h1.gif:image:w150]
--- out
<a href="http://www.hatena.ne.jp/images/top/h1.gif" target="_blank"><img src="http://www.hatena.ne.jp/images/top/h1.gif" alt="http://www.hatena.ne.jp/images/top/h1.gif" class="hatena-http-image" width="150"></a>

=== 03_autolink_http.t 5
--- in a_target_blank do_auto_link
[http://www.hatena.ne.jp/mobile/:barcode]
--- out
<a href="http://www.hatena.ne.jp/mobile/" target="_blank"><img src="http://d.hatena.ne.jp/barcode?str=http%3a%2f%2fwww%2ehatena%2ene%2ejp%2fmobile%2f" class="barcode" alt="http://www.hatena.ne.jp/mobile/"></a>

=== 03_autolink_http.t 6
--- in a_target_blank do_auto_link
This is our secure site. https://www.hatena.ne.jp/
--- out
This is our secure site. <a href="https://www.hatena.ne.jp/" target="_blank">https://www.hatena.ne.jp/</a>

=== 03_autolink_http.t 7
--- SKIP
--- in a_target_blank do_auto_link
This is our site. [http://www.hatena.ne.jp/:title=Hatena]
--- out
This is our site. <a href="http://www.hatena.ne.jp/" target="_blank">Hatena</a>

=== 03_autolink_http.t 8
--- SKIP
--- in a_target_blank do_auto_link
This is our site. [http://www.hatena.ne.jp/:title]
--- out
This is our site. <a href="http://www.hatena.ne.jp/" target="_blank">はてな</a>

=== 03_autolink_http.t 9
--- SKIP
--- in a_target_blank do_auto_link
This is our site. [http://www.hatena.ne.jp/:detail]
--- out
This is our site. <div class="hatena-http-detail"><p class="hatena-http-detail-url"><a href="http://www.hatena.ne.jp/" target="_blank">http://www.hatena.ne.jp/</a></p><p class="hatena-http-detail-title">はてな</p></div>

=== 04_autolink_ftp.t 1
--- in do_auto_link
This is our files. ftp://www.hatena.ne.jp/
--- out
This is our files. <a href="ftp://www.hatena.ne.jp/">ftp://www.hatena.ne.jp/</a>

=== 05_autolink_mailto.t 1
--- in do_auto_link
send me a mail mailto:info@example.com
--- out
send me a mail <a href="mailto:info@example.com">mailto:info@example.com</a>

=== 07_autolink_hatenagroup.t 1
--- in a_target_blank do_auto_link
This is my archive. g:hatena:id:sample:archive
--- out
This is my archive. <a href="http://hatena.g.hatena.ne.jp/sample/archive">g:hatena:id:sample:archive</a>

=== 07_autolink_hatenagroup.t 2
--- in a_target_blank do_auto_link
This is my archive. g:hatena:id:sample:archive:200601
--- out
This is my archive. <a href="http://hatena.g.hatena.ne.jp/sample/archive/200601">g:hatena:id:sample:archive:200601</a>

=== 07_autolink_hatenagroup.t 3
--- in a_target_blank do_auto_link
This is my gdiary. g:hatena:id:sample
--- out
This is my gdiary. <a href="http://hatena.g.hatena.ne.jp/sample/">g:hatena:id:sample</a>

=== 07_autolink_hatenagroup.t 4
--- in a_target_blank do_auto_link
This is my article. g:hatena:id:sample:20060121:1137814960
--- out
This is my article. <a href="http://hatena.g.hatena.ne.jp/sample/20060121/1137814960">g:hatena:id:sample:20060121:1137814960</a>

=== 07_autolink_hatenagroup.t 5
--- in a_target_blank do_auto_link
see [g:hatena:keyword:はてな情報削除関連事例]
--- out
see <a class="okeyword" href="http://hatena.g.hatena.ne.jp/keyword/%e3%81%af%e3%81%a6%e3%81%aa%e6%83%85%e5%a0%b1%e5%89%8a%e9%99%a4%e9%96%a2%e9%80%a3%e4%ba%8b%e4%be%8b">g:hatena:keyword:はてな情報削除関連事例</a>

=== 07_autolink_hatenagroup.t 6
--- in a_target_blank do_auto_link
g:texthatena:bbs:1:1
--- out
<a href="http://texthatena.g.hatena.ne.jp/bbs/1/1">g:texthatena:bbs:1:1</a>

=== 12_autolink_unblacket.t 1
--- in do_auto_link
I don\'t want to link []id:jkondo[].
--- out
I don\'t want to link id:jkondo.

=== 20_autolink_hatenamap.t 1
--- in a_target_blank do_auto_link
Many cafes [map:t:cafe]
--- out
Many cafes <a href="http://map.hatena.ne.jp/t/cafe" target="_blank">map:t:cafe</a>

=== 20_autolink_hatenamap.t 2
--- in a_target_blank do_auto_link
Here is our office. map:x139.6981y35.6515
--- out
Here is our office. <a href="http://map.hatena.ne.jp/?x=139.6981&y=35.6515&z=4" target="_blank">map:x139.6981y35.6515</a>

=== 20_autolink_hatenamap.t 3
--- in a_target_blank do_auto_link
Shibuya sta. [map:渋谷駅]
--- out
Shibuya sta. <a href="http://map.hatena.ne.jp/?word=%e6%b8%8b%e8%b0%b7%e9%a7%85" target="_blank">map:渋谷駅</a>

=== 21_autolink_google.t 1
--- in a_target_blank do_auto_link
Hatena news. [google:news:はてな]
--- out
Hatena news. <a href="http://news.google.com/news?q=%e3%81%af%e3%81%a6%e3%81%aa&ie=utf-8&oe=utf-8" target="_blank">google:news:はてな</a>

=== 21_autolink_google.t 2
--- in a_target_blank do_auto_link
Hatena images. [google:images:はてな]
--- out
Hatena images. <a href="http://images.google.com/images?q=%e3%81%af%e3%81%a6%e3%81%aa&ie=utf-8&oe=utf-8" target="_blank">google:images:はてな</a>

=== 21_autolink_google.t 3
--- in a_target_blank do_auto_link
Google search results. [google:Text::Hatena]
--- out
Google search results. <a href="http://www.google.com/search?q=Text%3a%3aHatena&ie=utf-8&oe=utf-8" target="_blank">google:Text::Hatena</a>

=== 22_autolink_hatenasearch.t 1
--- in a_target_blank do_auto_link
[search:question:はてな]
--- out
<a href="http://search.hatena.ne.jp/questsearch?word=%e3%81%af%e3%81%a6%e3%81%aa&ie=utf8" target="_blank">search:question:はてな</a>

=== 22_autolink_hatenasearch.t 2
--- in a_target_blank do_auto_link
[search:asin:はてな]
--- out
<a href="http://search.hatena.ne.jp/asinsearch?word=%e3%81%af%e3%81%a6%e3%81%aa&ie=utf8" target="_blank">search:asin:はてな</a>

=== 22_autolink_hatenasearch.t 3
--- in a_target_blank do_auto_link
[search:web:はてな]
--- out
<a href="http://search.hatena.ne.jp/websearch?word=%e3%81%af%e3%81%a6%e3%81%aa&ie=utf8" target="_blank">search:web:はてな</a>

=== 22_autolink_hatenasearch.t 4
--- in a_target_blank do_auto_link
[search:keyword:はてな]
--- out
<a href="http://search.hatena.ne.jp/keyword?word=%e3%81%af%e3%81%a6%e3%81%aa&ie=utf8" target="_blank">search:keyword:はてな</a>

=== 22_autolink_hatenasearch.t 5
--- in a_target_blank do_auto_link
[search:はてな]
--- out
<a href="http://search.hatena.ne.jp/keyword?word=%e3%81%af%e3%81%a6%e3%81%aa&ie=utf8" target="_blank">search:はてな</a>

=== 24_autolink_rakuten.t 1
--- in a_target_blank do_auto_link
Hatena goods. [rakuten:はてな]
--- out
Hatena goods. <a href="http://pt.afl.rakuten.co.jp/c/002e8f0a.89099887/?sv=2&v=3&p=0&sitem=%a4%cf%a4%c6%a4%ca" target="_blank">rakuten:はてな</a>

=== 99_autolink.t 1
--- in do_auto_link
Here is my album. f:id:sample
--- out
Here is my album. <a href="http://f.hatena.ne.jp/sample/">f:id:sample</a>

=== 99_autolink.t
--- in do_auto_link
Hatena news. [google:news:はてな]
--- out
Hatena news. <a href="http://news.google.com/news?q=%e3%81%af%e3%81%a6%e3%81%aa&ie=utf-8&oe=utf-8">google:news:はてな</a>

=== 99_autolink.t
--- in hatenaize
*Hi
This is my blog.
http://d.hatena.ne.jp/jkondo/
--- out
<div class="section">
	<h3><a href="http://d.hatena.ne.jp/jkondo/20050906#p1" name="p1"><span class="sanchor">sa</span></a> Hi</h3>
	<p>This is my blog.</p>
	<p><a href="http://d.hatena.ne.jp/jkondo/">http://d.hatena.ne.jp/jkondo/</a></p>
</div>

=== 99_autolink.t
--- SKIP
--- in hatenaize
*Hi
This is our site. [http://www.hatena.ne.jp/:detail] Please visit.
><blockquote>
[http://www.hatena.ne.jp/:detail]
</blockquote><
--- out
<div class="section">
	<h3><a href="http://d.hatena.ne.jp/jkondo/20050906#p1" name="p1"><span class="sanchor">sa</span></a> Hi</h3>
	<p>This is our site. </p><div class="hatena-http-detail"><p class="hatena-http-detail-url"><a href="http://www.hatena.ne.jp/">http://www.hatena.ne.jp/</a></p><p class="hatena-http-detail-title">はてな</p></div><p> Please visit.</p>
	<blockquote>
		<div class="hatena-http-detail"><p class="hatena-http-detail-url"><a href="http://www.hatena.ne.jp/">http://www.hatena.ne.jp/</a></p><p class="hatena-http-detail-title">はてな</p></div>
	</blockquote>
</div>

=== 99_autolink.t
--- SKIP
--- in hatenaize
*Introducing my book.
Here is my book.
[asin:4798110523:image]
--- out
<div class="section">
	<h3><a href="http://d.hatena.ne.jp/jkondo/20050906#p1" name="p1"><span class="sanchor">sa</span></a> Introducing my book.</h3>
	<p>Here is my book.</p>
	<p><a href="http://d.hatena.ne.jp/asin/4798110523"><img src="http://images-jp.amazon.com/images/P/4798110523.09.MZZZZZZZ.jpg" alt="「へんな会社」のつくり方" title="「へんな会社」のつくり方" class="asin"></a></p>
</div>

=== 99_autolink.t
--- SKIP
--- in hatenaize
*Introducing my book.
Here is my book.
[asin:4798110523:image]
--- out
<div class="section">
	<h3><a href="http://d.hatena.ne.jp/jkondo/20050906#p1" name="p1"><span class="sanchor">sa</span></a> Introducing my book.</h3>
	<p>Here is my book.</p>
	<p><a href="http://d.hatena.ne.jp/asin/4798110523"><img src="http://images-jp.amazon.com/images/P/4798110523.09.MZZZZZZZ.jpg" alt="「へんな会社」のつくり方" title="「へんな会社」のつくり方" class="asin"></a></p>
</div>

=== 99_autolink.t
--- in hatenaize
Hello, []id:jkondo[].
--- out
<div class="section">
	<p>Hello, id:jkondo.</p>
</div>

=== 99_autolink.t
--- in a_target_blank scheme_option do_auto_link
http://www.hatena.ne.jp/ &gt; id:jkondo
--- out
<a href="http://www.hatena.ne.jp/" target="_blank">http://www.hatena.ne.jp/</a> &gt; <a href="/jkondo/">id:jkondo</a>

=== 99_autolink.t
--- in autolink_option hatenaize
http://www.hatena.ne.jp/ &gt; id:jkondo
--- out
<div class="section">
	<p><a href="http://www.hatena.ne.jp/" target="_top">http://www.hatena.ne.jp/</a> &gt; <a href="/jkondo/" target="_blank">id:jkondo</a></p>
</div>
