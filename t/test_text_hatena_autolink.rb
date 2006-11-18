# -*- mode: ruby; coding: utf-8 -*-
require "t/test_helper"
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
end

__END__
=== 02_autolink_text.t
--- in do_auto_link
Hi, this is a simple text.
--- out
Hi, this is a simple text.

=== 03_autolink_http.t
--- in do_auto_link
This is our site. http://www.hatena.ne.jp/
--- out
This is our site. <a href="http://www.hatena.ne.jp/">http://www.hatena.ne.jp/</a>

=== 03_autolink_http.t
--- in a_target_blank do_auto_link
This is our site. http://www.hatena.ne.jp/
--- out
This is our site. <a href="http://www.hatena.ne.jp/" target="_blank">http://www.hatena.ne.jp/</a>

=== 03_autolink_http.t
--- in do_auto_link
[http://www.hatena.ne.jp/images/top/h1.gif:image]
--- out
<a href="http://www.hatena.ne.jp/images/top/h1.gif"><img src="http://www.hatena.ne.jp/images/top/h1.gif" alt="http://www.hatena.ne.jp/images/top/h1.gif" class="hatena-http-image"></a>

=== 03_autolink_http.t
--- in a_target_blank do_auto_link
[http://www.hatena.ne.jp/images/top/h1.gif:image:w150]
--- out
<a href="http://www.hatena.ne.jp/images/top/h1.gif" target="_blank"><img src="http://www.hatena.ne.jp/images/top/h1.gif" alt="http://www.hatena.ne.jp/images/top/h1.gif" class="hatena-http-image" width="150"></a>

=== 03_autolink_http.t
--- in a_target_blank do_auto_link
[http://www.hatena.ne.jp/mobile/:barcode]
--- out
<a href="http://www.hatena.ne.jp/mobile/" target="_blank"><img src="http://d.hatena.ne.jp/barcode?str=http%3a%2f%2fwww%2ehatena%2ene%2ejp%2fmobile%2f" class="barcode" alt="http://www.hatena.ne.jp/mobile/"></a>

=== 03_autolink_http.t
--- in a_target_blank do_auto_link
This is our secure site. https://www.hatena.ne.jp/
--- out
This is our secure site. <a href="https://www.hatena.ne.jp/" target="_blank">https://www.hatena.ne.jp/</a>

=== 03_autolink_http.t
--- in a_target_blank do_auto_link
This is our site. [http://www.hatena.ne.jp/:title=Hatena]
--- out
This is our site. <a href="http://www.hatena.ne.jp/" target="_blank">Hatena</a>

=== 03_autolink_http.t
--- in a_target_blank do_auto_link
This is our site. [http://www.hatena.ne.jp/:title]
--- out
This is our site. <a href="http://www.hatena.ne.jp/" target="_blank">はてな</a>

=== 03_autolink_http.t
--- in a_target_blank do_auto_link
This is our site. [http://www.hatena.ne.jp/:detail]
--- out
This is our site. <div class="hatena-http-detail"><p class="hatena-http-detail-url"><a href="http://www.hatena.ne.jp/" target="_blank">http://www.hatena.ne.jp/</a></p><p class="hatena-http-detail-title">はてな</p></div>

=== 04_autolink_ftp.t
--- in do_auto_link
This is our files. ftp://www.hatena.ne.jp/
--- out
This is our files. <a href="ftp://www.hatena.ne.jp/">ftp://www.hatena.ne.jp/</a>

=== 05_autolink_mailto.t
--- SKIP
--- in do_autolink
send me a mail mailto:info@example.com
--- out
send me a mail <a href="mailto:info@example.com">mailto:info@example.com</a>

=== 12_autolink_unblacket.t
--- in do_auto_link
I don\'t want to link []id:jkondo[].
--- out
I don\'t want to link id:jkondo.

=== 99_autolink.t
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
