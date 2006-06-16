# -*- mode: ruby; coding: utf-8 -*-

$:.unshift(File.join(File.dirname(__FILE__), "..", "lib"))

require "test/unit"
require "text/hatena/auto_link"

class Test_Text_Hatena_AutoLink < Test::Unit::TestCase
  # 01_autolink_compile.t
  def test_01
    assert_instance_of(Class, Text::Hatena::AutoLink)
  end

  # 02_autolink_text.t
  def test_02
    t = Text::Hatena::AutoLink.new
    text = "Hi, this is a simple text."
    html = t.parse(text)
    assert_equal(text, html)
  end

  # 03_autolink_http.t
  def test_03
    t = Text::Hatena::AutoLink::HTTP.new
    pat = t.pattern

    text = "This is our site. http://www.hatena.ne.jp/"
    html = text.gsub(pat) do |m|
      t.parse(m)
    end

    html2 = 'This is our site. <a href="http://www.hatena.ne.jp/">http://www.hatena.ne.jp/</a>'
    assert_equal(html2, html)

    t = Text::Hatena::AutoLink::HTTP.new({:a_target => "_blank"})

    text = "This is our site. http://www.hatena.ne.jp/"
    html = text.gsub(pat) do |m|
      t.parse(m)
    end

    html2 = 'This is our site. <a href="http://www.hatena.ne.jp/" target="_blank">http://www.hatena.ne.jp/</a>'
    assert_equal(html2, html)

    t = Text::Hatena::AutoLink::HTTP.new
    text = "[http://www.hatena.ne.jp/images/top/h1.gif:image]"
    html = text.gsub(/(#{pat})/) do
      t.parse($1)
    end

    html2 = '<a href="http://www.hatena.ne.jp/images/top/h1.gif"><img src="http://www.hatena.ne.jp/images/top/h1.gif" alt="http://www.hatena.ne.jp/images/top/h1.gif" class="hatena-http-image"></a>'
    assert_equal(html2, html)

    t = Text::Hatena::AutoLink::HTTP.new({:a_target => "_blank"})
    text = "[http://www.hatena.ne.jp/images/top/h1.gif:image:w150]"
    html = text.gsub(/(#{pat})/) do
      t.parse($1)
    end

    html2 = '<a href="http://www.hatena.ne.jp/images/top/h1.gif" target="_blank"><img src="http://www.hatena.ne.jp/images/top/h1.gif" alt="http://www.hatena.ne.jp/images/top/h1.gif" class="hatena-http-image" width="150"></a>'
    assert_equal(html2, html)

    text = '[http://www.hatena.ne.jp/mobile/:barcode]'
    html = text.gsub(/(#{pat})/) do
      t.parse($1)
    end

    html2 = '<a href="http://www.hatena.ne.jp/mobile/" target="_blank"><img src="http://d.hatena.ne.jp/barcode?str=http%3a%2f%2fwww%2ehatena%2ene%2ejp%2fmobile%2f" class="barcode" alt="http://www.hatena.ne.jp/mobile/"></a>'
    assert_equal(html2, html)

    text = 'This is our secure site. https://www.hatena.ne.jp/'
    html = text.gsub(/(#{pat})/) do
      t.parse($1)
    end

    html2 = 'This is our secure site. <a href="https://www.hatena.ne.jp/" target="_blank">https://www.hatena.ne.jp/</a>'
    assert_equal(html2, html)

    text = 'This is our site. [http://www.hatena.ne.jp/:title=Hatena]'
    html = text.gsub(/(#{pat})/) do
      t.parse($1)
    end

    html2 = 'This is our site. <a href="http://www.hatena.ne.jp/" target="_blank">Hatena</a>'
    assert_equal(html2, html)

    text = 'This is our site. [http://www.hatena.ne.jp/:title]'
    html = text.gsub(/(#{pat})/) do
      t.parse($1)
    end

    html2 = 'This is our site. <a href="http://www.hatena.ne.jp/" target="_blank">はてな</a>'
    assert_equal(html2, html)

    text = 'This is our site. [http://www.hatena.ne.jp/:detail]'
    html = text.gsub(/(#{pat})/) do
      t.parse($1)
    end

    html2 = 'This is our site. <div class="hatena-http-detail"><p class="hatena-http-detail-url"><a href="http://www.hatena.ne.jp/" target="_blank">http://www.hatena.ne.jp/</a></p><p class="hatena-http-detail-title">はてな</p></div>'
    assert_equal(html2, html)
  end

  # 04_autolink_ftp.t
  def test_04
    t = Text::Hatena::AutoLink::FTP.new
    pat = t.pattern

    text = 'This is our files. ftp://www.hatena.ne.jp/'
    html = text.gsub(/(#{pat})/) do
      t.parse($1)
    end

    html2 = 'This is our files. <a href="ftp://www.hatena.ne.jp/">ftp://www.hatena.ne.jp/</a>'
    assert_equal(html2, html)
  end

  # 12_autolink_unbracket.t
  def test_12
    t = Text::Hatena::AutoLink::Unbracket.new
    pat = t.pattern

    text = 'I don\'t want to link []id:jkondo[].'
    html = text.gsub(/(#{pat})/) do
      t.parse($1)
    end
    html2 = 'I don\'t want to link id:jkondo.'
    assert_equal(html2, html)
  end

  # 99_autolink.t
  def test_99
    t = Text::Hatena::AutoLink.new

    text = 'Here is my album. f:id:sample'
    html = t.parse(text)
    html2 = 'Here is my album. <a href="http://f.hatena.ne.jp/sample/">f:id:sample</a>'
    assert_equal(html2, html)

    text = 'Hatena news. [google:news:はてな]'
    html = t.parse(text)
    html2 = 'Hatena news. <a href="http://news.google.com/news?q=%e3%81%af%e3%81%a6%e3%81%aa&ie=utf-8&oe=utf-8">google:news:はてな</a>'
    assert_equal(html2, html)

    base = 'http://d.hatena.ne.jp/jkondo'
    parma = 'http://d.hatena.ne.jp/jkondo/20050906'
    sa = 'sa'

    p = Text::Hatena.new(:baseuri => base,
                         :permalink => parma,
                         :ilevel => 0,
                         :ivalidnode => [],
                         :sectionanchor => sa)

    text = <<END
*Hi
This is my blog.
http://d.hatena.ne.jp/jkondo/
END

    html2 = <<END
<div class="section">
	<h3><a href="http://d.hatena.ne.jp/jkondo/20050906#p1" name="p1"><span class="sanchor">sa</span></a> Hi</h3>
	<p>This is my blog.</p>
	<p><a href="http://d.hatena.ne.jp/jkondo/">http://d.hatena.ne.jp/jkondo/</a></p>
</div>
END

    p.parse(text)
    html = p.html
    html2.chomp!

    assert_equal(html2, html)
  end
end
