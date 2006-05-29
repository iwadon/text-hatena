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
    Text::Hatena::AutoLink.new
    t = Text::Hatena::AutoLink::HTTP.new
    pat = t.pattern

    text = "This is our site. http://www.hatena.ne.jp/"
    html = text.gsub(pat) do |m|
      t.parse(m)
    end

    html2 = 'This is our site. <a href="http://www.hatena.ne.jp/">http://www.hatena.ne.jp/</a>'
    assert_equal(html2, html)
  end
end
