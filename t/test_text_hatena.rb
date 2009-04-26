require "t/test_helper"

class TextHatenaTest < Test::Base
  filters %w(.strip)
  filters :in => "hatenaize"
  delimitors '===', ';;;'
  run_equal :out, :in

  def hatenaize(value)
    parser = Text::Hatena.new({ :baseuri => "http://d.hatena.ne.jp/jkondo/",
                                :permalink => "http://d.hatena.ne.jp/jkondo/20050906",
                                :ilevel => 0,
                                :invalidnode => [],
                                :sectionanchor => "sa" })
    parser.parse(value)
    parser.html
  end
end

__END__
===
;;; in
*title
body

;;; out
<div class="section">
	<h3><a href="http://d.hatena.ne.jp/jkondo/20050906#p1" name="p1"><span class="sanchor">sa</span></a> title</h3>
	<p>body</p>
</div>

===
;;; in
*1234567890*record time
remember time.

;;; out
<div class="section">
	<h3><a href="http://d.hatena.ne.jp/jkondo/20050906#1234567890" name="1234567890"><span class="sanchor">sa</span></a> record time</h3> <span class="timestamp">08:31</span>
	<p>remember time.</p>
</div>

===
;;; in
*hobby*[hobby]my hobby
I like this.

;;; out
<div class="section">
	<h3><a href="http://d.hatena.ne.jp/jkondo/20050906#hobby" name="hobby"><span class="sanchor">sa</span></a> [<a href="http://d.hatena.ne.jp/jkondo/?word=hobby" class="sectioncategory">hobby</a>]my hobby</h3>
	<p>I like this.</p>
</div>

===
;;; in
**h4title

h4body

;;; out
<div class="section">
	<h4>h4title</h4>
	
	<p>h4body</p>
</div>

===
;;; in
***h5title

h5body

;;; out
<div class="section">
	<h5>h5title</h5>
	
	<p>h5body</p>
</div>

===
;;; in
>>
quoted
<<

;;; out
<div class="section">
	<blockquote>
		<p>quoted</p>
	</blockquote>
</div>

===
;;; in
:cinnamon:dog

;;; out
<div class="section">
	<dl>
		<dt>cinnamon</dt>
		<dd>dog</dd>
	</dl>
</div>

===
;;; in
-komono
--kyoto
---shibuya
--hachiyama

;;; out
<div class="section">
	<ul>
		<li>komono
		<ul>
			<li>kyoto
			<ul>
				<li>shibuya</li>
			</ul>
			</li>
			<li>hachiyama</li>
		</ul>
		</li>
	</ul>
</div>

===
;;; in
+komono
+kyoto
+shibuya

;;; out
<div class="section">
	<ol>
		<li>komono</li>
		<li>kyoto</li>
		<li>shibuya</li>
	</ol>
</div>

===
;;; in
>|
#!/usr/bin/perl
|<

;;; out
<div class="section">
	<pre>
#!/usr/bin/perl
</pre>
</div>

=== super-pre
;;; in
>||
html starts with <html>.
||<

;;; out
<div class="section">
	<pre class="hatena-super-pre">
html starts with &lt;html&gt;.
</pre>
</div>

===
;;; in
|*Lang|*Module|
|Perl|Text::Hatena|

;;; out
<div class="section">
	<table>
		<tr>
			<th>Lang</th>
			<th>Module</th>
		</tr>
		<tr>
			<td>Perl</td>
			<td>Text::Hatena</td>
		</tr>
	</table>
</div>

===
;;; in
><div>no paragraph line</div><
paragraph line

;;; out
<div class="section">
	<div>no paragraph line</div>
	<p>paragraph line</p>
</div>

===
;;; in
><blockquote>
no paragraph
lines
</blockquote><
paragraph
lines

;;; out
<div class="section">
	<blockquote>
		no paragraph
		lines
	</blockquote>
	<p>paragraph</p>
	<p>lines</p>
</div>

===
;;; in
><blockquote cite="http://www.hatena.ne.jp/">
Hatena
</blockquote><
;;; out
<div class="section">
	<blockquote cite="http://www.hatena.ne.jp/">
		Hatena
	<cite><a href="http://www.hatena.ne.jp/">*</a></cite></blockquote>
</div>

===
;;; in
><blockquote cite="http://www.hatena.ne.jp/" title="Hatena">
Hatena
</blockquote><
;;; out
<div class="section">
	<blockquote cite="http://www.hatena.ne.jp/" title="Hatena">
		Hatena
	<cite><a href="http://www.hatena.ne.jp/">Hatena</a></cite></blockquote>
</div>

===
;;; in
This is <q cite="http://www.hatena.ne.jp/">a inline quote</q>.
;;; out
<div class="section">
	<p>This is <q cite="http://www.hatena.ne.jp/">a inline quote<cite><a href="http://www.hatena.ne.jp/">*</a></cite></q>.</p>
</div>

===
;;; in
This is <q cite="http://www.hatena.ne.jp/" title="Hatena">a inline quote</q>.
;;; out
<div class="section">
	<p>This is <q cite="http://www.hatena.ne.jp/" title="Hatena">a inline quote<cite><a href="http://www.hatena.ne.jp/">Hatena</a></cite></q>.</p>
</div>

===
;;; in
Here is the way to make link.
>||
http://www.hatena.ne.jp/
id:jkondo
||<
bye.

;;; out
<div class="section">
	<p>Here is the way to make link.</p>
	<pre class="hatena-super-pre">
http://www.hatena.ne.jp/
id:jkondo
</pre>
	<p>bye.</p>
</div>

===
;;; in .strip
GNU((GNU Is Not Unix)) is not unix.

;;; out
<div class="section">
	<p>GNU<span class="footnote"><a href="http://d.hatena.ne.jp/jkondo/20050906#f1" title="GNU Is Not Unix" name="fn1">*1</a></span> is not unix.</p>
</div>
<div class="footnote">
	<p class="footnote"><a href="http://d.hatena.ne.jp/jkondo/20050906#fn1" name="f1">*1</a>: GNU Is Not Unix</p>
</div>
