require "test/unit"
require "text/hatena"

class Test_Text_Hatena < Test::Unit::TestCase
  def setup
    @base = "http://d.hatena.ne.jp/jkondo/"
    @perma = "http://d.hatena.ne.jp/jkondo/20050906"
    @sa = "sa"
    @p = Text::Hatena.new({ :baseuri => @base,
                            :permalink => @perma,
                            :ilevel => 0,
                            :invalidnode => [],
                            :sectionanchor => @sa })
  end

  def test_all
    assert_instance_of(Text::Hatena, @p)

    # h3
    text = <<END
*title
body
END
    html2 = <<END
<div class="section">
\t<h3><a name="p1" href="http://d.hatena.ne.jp/jkondo/20050906#p1"><span class="sanchor">sa</span></a> title</h3>
\t<p>body</p>
</div>
END
    @p.parse(text)
    html = @p.html
    html2.chomp!
    assert_equal(html2, html)

    # h3time
    text = <<END
*1234567890*record time
remember time.
END
    html2 = <<END
<div class="section">
\t<h3><a name="1234567890" href="http://d.hatena.ne.jp/jkondo/20050906#1234567890"><span class="sanchor">sa</span></a> record time</h3> <span class="timestamp">08:31</span>
\t<p>remember time.</p>
</div>
END
    @p.parse(text)
    html = @p.html
    html2.chomp!
    assert_equal(html2, html)


    # h3cat
    text = <<END
*hobby*[hobby]my hobby
I like this.
END
    html2 = <<END
<div class="section">
\t<h3><a name="hobby" href="http://d.hatena.ne.jp/jkondo/20050906#hobby"><span class="sanchor">sa</span></a> [<a href="http://d.hatena.ne.jp/jkondo/?word=hobby" class="sectioncategory">hobby</a>]my hobby</h3>
\t<p>I like this.</p>
</div>
END
    @p.parse(text)
    html = @p.html
    html2.chomp!
    assert_equal(html2, html)


    # h4
    text = <<END;
**h4title

h4body
END
    html2 = <<END
<div class="section">
\t<h4>h4title</h4>
\t
\t<p>h4body</p>
</div>
END
    @p.parse(text)
    html = @p.html
    html2.chomp!
    assert_equal(html2, html)

    # h5
    text = <<END
***h5title

h5body
END
    html2 = <<END
<div class="section">
\t<h5>h5title</h5>
\t
\t<p>h5body</p>
</div>
END
    @p.parse(text)
    html = @p.html
    html2.chomp!
    assert_equal(html2, html)

    # blockquote
    text = <<END
>>
quoted
<<
END
    html2 = <<END
<div class="section">
\t<blockquote>
\t\t<p>quoted</p>
\t</blockquote>
</div>
END
    @p.parse(text)
    html = @p.html
    html2.chomp!
    assert_equal(html2, html)

    # dl
    text = <<END
:cinnamon:dog
END
    html2 = <<END
<div class="section">
\t<dl>
\t\t<dt>cinnamon</dt>
\t\t<dd>dog</dd>
\t</dl>
</div>
END
    @p.parse(text)
    html = @p.html
    html2.chomp!
    assert_equal(html2, html)

    # ul
    text = <<END
-komono
--kyoto
---shibuya
--hachiyama
END
    html2 = <<END
<div class="section">
\t<ul>
\t\t<li>komono
\t\t<ul>
\t\t\t<li>kyoto
\t\t\t<ul>
\t\t\t\t<li>shibuya</li>
\t\t\t</ul>
\t\t\t</li>
\t\t\t<li>hachiyama</li>
\t\t</ul>
\t\t</li>
\t</ul>
</div>
END
    @p.parse(text)
    html = @p.html
    html2.chomp!
    assert_equal(html2, html)


    # ol
    text = <<END
+komono
+kyoto
+shibuya
END
    html2 = <<END
<div class="section">
\t<ol>
\t\t<li>komono</li>
\t\t<li>kyoto</li>
\t\t<li>shibuya</li>
\t</ol>
</div>
END
    @p.parse(text)
    html = @p.html
    html2.chomp!
    assert_equal(html2, html)

    # pre
    text = <<END
>|
#!/usr/bin/perl
|<
END
    html2 = <<END
<div class="section">
\t<pre>
#!/usr/bin/perl
</pre>
</div>
END
    @p.parse(text)
    html = @p.html
    html2.chomp!
    assert_equal(html2, html)

    # superpre
    text = <<END
>||
html starts with <html>.
||<
END
    html2 = <<END
<div class="section">
\t<pre>
html starts with &lt;html&gt;.
</pre>
</div>
END
    @p.parse(text)
    html = @p.html
    html2.chomp!
    assert_equal(html2, html)

    # table
    text = <<END
|*Lang|*Module|
|Perl|Text::Hatena|
END
    html2 = <<END
<div class="section">
\t<table>
\t\t<tr>
\t\t\t<th>Lang</th>
\t\t\t<th>Module</th>
\t\t</tr>
\t\t<tr>
\t\t\t<td>Perl</td>
\t\t\t<td>Text::Hatena</td>
\t\t</tr>
\t</table>
</div>
END
    @p.parse(text)
    html = @p.html
    html2.chomp!
    assert_equal(html2, html)

    # tagline
    text = <<END
><div>no paragraph line</div><
paragraph line
END
    html2 = <<END
<div class="section">
\t<div>no paragraph line</div>
\t<p>paragraph line</p>
</div>
END
    @p.parse(text)
    html = @p.html
    html2.chop!
    assert_equal(html2, html)

    # tag
    text = <<END
><blockquote>
no paragraph
lines
</blockquote><
paragraph
lines
END
    html2 = <<END
<div class="section">
\t<blockquote>
\t\tno paragraph
\t\tlines
\t</blockquote>
\t<p>paragraph</p>
\t<p>lines</p>
</div>
END
    @p.parse(text)
    html = @p.html
    html2.chomp!
    assert_equal(html2, html)

    # footnote
    text = <<END
GNU((GNU Is Not Unix)) is not unix.
END
    html2 = <<END
<div class="section">
\t<p>GNU<span class="footnote"><a name="fn1" href="http://d.hatena.ne.jp/jkondo/20050906#f1" title="GNU Is Not Unix">*1</a></span> is not unix.</p>
</div>
<div class="footnote">
\t<p class="footnote"><a href="http://d.hatena.ne.jp/jkondo/20050906#fn1" name="f1">*1</a>: GNU Is Not Unix</p>
</div>
END
     @p.parse(text)
     html = @p.html
     assert_equal(html2, html)
  end
end
