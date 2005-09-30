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

    a = ["title", "body"]
    text = h3text(*a)
    @p.parse(text)
    html = @p.html
    assert_match(/<h3>/, html)
    assert_match(/<div class="section">/, html)
    assert_match(/#{@perma}/, html)
    assert_match(%r!<span class="sanchor">#{@sa}</span>!, html)
    assert_match(/#{a[0]}/, html)
    assert_match(%r!<p>#{a[1]}</p>!, html)

    a = [1234567890]
    text = h3timetext(*a)
    @p.parse(text)
    html = @p.html
    assert_match(/\##{a[0]}/, html)
    assert_match(/name="#{a[0]}"/, html)
    assert_match(%r!<span class="timestamp">08:31</span>!, html)

    a = ["hobby"]
    text = h3cattext(*a)
    @p.parse(text)
    html = @p.html
    assert_match(/\##{a[0]}/, html)
    assert_match(/name="#{a[0]}"/, html)
    assert_match(%r!\[<a[^>]+>#{a[0]}</a>\]!i, html)

    a = ["h4title"]
    text = h4text(*a)
    @p.parse(text)
    html = @p.html
    assert_match(%r!<h4>#{a[0]}</h4>!, html)

    a = ["h5title"]
    text = h5text(*a)
    @p.parse(text)
    html = @p.html
    assert_match(%r!<h5>#{a[0]}</h5>!, html)

    a = ["quoted"]
    text = blockquotetext(*a)
    @p.parse(text)
    html = @p.html
    assert_match(/<blockquote>/, html)
    assert_match(%r!<p>#{a[0]}</p>!, html)

    a = ["cinnamon", "dog"]
    text = dltext(*a)
    @p.parse(text)
    html = @p.html
    assert_match(/<dl>/, html)
    assert_match(%r!<dt>#{a[0]}</dt>!, html)
    assert_match(%r!<dd>#{a[1]}</dd>!, html)

    a = ["komono", "kyoto", "shibuya"]
    text = ultext(*a)
    @p.parse(text)
    html = @p.html
    assert_match(/<ul>/, html)
    assert_match(%r!<li>#{a[0]}</li>!, html)
    assert_match(%r!<li>#{a[1]}</li>!, html)
    assert_match(%r!<li>#{a[2]}</li>!, html)

    text = ultext2(*a)
    @p.parse(text)
    html = @p.html
    assert_match(/<ul>.+<ul>.+<ul>/m, html)
    assert_match(%r!<li>#{a[0]}</li>!, html)
    assert_match(%r!<li>#{a[1]}</li>!, html)
    assert_match(%r!<li>#{a[2]}</li>!, html)

    text = oltext(*a)
    @p.parse(text)
    html = @p.html
    assert_match(/<ol>/, html)
    assert_match(%r!<li>#{a[0]}</li>!, html)
    assert_match(%r!<li>#{a[1]}</li>!, html)
    assert_match(%r!<li>#{a[2]}</li>!, html)

    a = ["#!/usr/bin/perl"]
    text = pretext(*a)
    @p.parse(text)
    html = @p.html
    assert_match(/<pre>/, html)
    assert_match(%r!#{a[0]}!, html)

    text = superpretext(*a)
    @p.parse(text)
    html = @p.html
    assert_match(/<pre>/, html)
    assert_match(%r!#{a[0]}!, html)

    a = ["Lang", "Module", "Perl", "Text::Hatena"]
    text = tabletext(*a)
    @p.parse(text)
    html = @p.html
    assert_match(%r!<table>.+</table>!m, html)
    assert_match(%r!<tr>.+</tr>.+<tr>.+</tr>!m, html)
    assert_match(%r!<th>#{a[0]}</th>!, html)
    assert_match(%r!<th>#{a[1]}</th>!, html)
    assert_match(%r!<td>#{a[2]}</td>!, html)
    assert_match(%r!<td>#{a[3]}</td>!, html)

    a = ["GNU", "GNU Is Not Unix", "is not unix"]
    text = footnotetext(*a)
    @p.parse(text)
    html = @p.html
    assert_match(%r!#{a[0]}<span class="footnote"><a.+?>\*1</a></span>#{a[2]}!, html)
    assert_match(%r!<p class="footnote"><a.+?>\*1</a>.+#{a[1]}</p>!m, html)
  end

  def h3text(title, body)
    <<END
*#{title}
#{body}
END
  end

  def h3timetext(time)
    <<END
*#{time}*record time
remember time.
END
  end

  def h3cattext(cat)
    <<END
*#{cat}*[#{cat}]my hobby
I like this.
END
  end

  def h4text(title)
    <<END
**#{title}

h4body
END
  end

  def h5text(title)
    <<END
***#{title}

h4body
END
  end

  def blockquotetext(str)
    <<END
>>
#{str}
<<
END
  end

  def dltext(term, desc)
    <<END
:#{term}:#{desc}
END
  end

  def ultext(a, b, c)
    <<END
-#{a}
-#{b}
-#{c}
END
  end

  def ultext2(a, b, c)
    <<END
-#{a}
--#{b}
---#{c}
END
  end

  def oltext(a, b, c)
    <<END
+#{a}
+#{b}
+#{c}
END
  end

  def pretext(str)
    <<END
>|
#{str}
|<
END
  end

  def superpretext(str)
    <<END
>||
#{str}
||<
END
  end

  def tabletext(a, b, c, d)
    <<END
|*#{a}|*#{b}|
|#{c}|#{d}|
END
  end

  def footnotetext(a, b, c)
    <<END
#{a}((#{b}))#{c}
END
  end
end
