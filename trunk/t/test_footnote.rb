require "t/test_helper"
require "text/hatena"

class FootnoteTest < Test::Base
  filters %w(.chomp)
  filters :in => 'hatenaize'
  run_equal :out, :in

  def hatenaize(value)
    parser = Text::Hatena.new({})
    parser.parse(value)
    parser.html
  end
end

__END__
===
--- in
てすと((ち))てすと((つ))てすと((て))てすと((と))
てすと((な))てすと((に))てすと((ぬ))てすと((ね))てすと((の))
てすと((は))てすと((ひ))てすと((ふ))てすと((へ))てすと((ほ))
てすと((ぢ))てすと((づ))てすと((で))てすと((ど))
てすと((ば))てすと((び))てすと((ぶ))てすと((べ))てすと((ぼ))
てすと((ぱ))てすと((ぴ))てすと((ぷ))てすと((ぺ))てすと((ぽ))
--- out
<div class="section">
	<p>てすと<span class="footnote"><a href="#f1" title="ち" name="fn1">*1</a></span>てすと<span class="footnote"><a href="#f2" title="つ" name="fn2">*2</a></span>てすと<span class="footnote"><a href="#f3" title="て" name="fn3">*3</a></span>てすと<span class="footnote"><a href="#f4" title="と" name="fn4">*4</a></span></p>
	<p>てすと<span class="footnote"><a href="#f5" title="な" name="fn5">*5</a></span>てすと<span class="footnote"><a href="#f6" title="に" name="fn6">*6</a></span>てすと<span class="footnote"><a href="#f7" title="ぬ" name="fn7">*7</a></span>てすと<span class="footnote"><a href="#f8" title="ね" name="fn8">*8</a></span>てすと<span class="footnote"><a href="#f9" title="の" name="fn9">*9</a></span></p>
	<p>てすと<span class="footnote"><a href="#f10" title="は" name="fn10">*10</a></span>てすと<span class="footnote"><a href="#f11" title="ひ" name="fn11">*11</a></span>てすと<span class="footnote"><a href="#f12" title="ふ" name="fn12">*12</a></span>てすと<span class="footnote"><a href="#f13" title="へ" name="fn13">*13</a></span>てすと<span class="footnote"><a href="#f14" title="ほ" name="fn14">*14</a></span></p>
	<p>てすと<span class="footnote"><a href="#f15" title="ぢ" name="fn15">*15</a></span>てすと<span class="footnote"><a href="#f16" title="づ" name="fn16">*16</a></span>てすと<span class="footnote"><a href="#f17" title="で" name="fn17">*17</a></span>てすと<span class="footnote"><a href="#f18" title="ど" name="fn18">*18</a></span></p>
	<p>てすと<span class="footnote"><a href="#f19" title="ば" name="fn19">*19</a></span>てすと<span class="footnote"><a href="#f20" title="び" name="fn20">*20</a></span>てすと<span class="footnote"><a href="#f21" title="ぶ" name="fn21">*21</a></span>てすと<span class="footnote"><a href="#f22" title="べ" name="fn22">*22</a></span>てすと<span class="footnote"><a href="#f23" title="ぼ" name="fn23">*23</a></span></p>
	<p>てすと<span class="footnote"><a href="#f24" title="ぱ" name="fn24">*24</a></span>てすと<span class="footnote"><a href="#f25" title="ぴ" name="fn25">*25</a></span>てすと<span class="footnote"><a href="#f26" title="ぷ" name="fn26">*26</a></span>てすと<span class="footnote"><a href="#f27" title="ぺ" name="fn27">*27</a></span>てすと<span class="footnote"><a href="#f28" title="ぽ" name="fn28">*28</a></span></p>
</div>
<div class="footnote">
	<p class="footnote"><a href="#fn1" name="f1">*1</a>: ち</p>
	<p class="footnote"><a href="#fn2" name="f2">*2</a>: つ</p>
	<p class="footnote"><a href="#fn3" name="f3">*3</a>: て</p>
	<p class="footnote"><a href="#fn4" name="f4">*4</a>: と</p>
	<p class="footnote"><a href="#fn5" name="f5">*5</a>: な</p>
	<p class="footnote"><a href="#fn6" name="f6">*6</a>: に</p>
	<p class="footnote"><a href="#fn7" name="f7">*7</a>: ぬ</p>
	<p class="footnote"><a href="#fn8" name="f8">*8</a>: ね</p>
	<p class="footnote"><a href="#fn9" name="f9">*9</a>: の</p>
	<p class="footnote"><a href="#fn10" name="f10">*10</a>: は</p>
	<p class="footnote"><a href="#fn11" name="f11">*11</a>: ひ</p>
	<p class="footnote"><a href="#fn12" name="f12">*12</a>: ふ</p>
	<p class="footnote"><a href="#fn13" name="f13">*13</a>: へ</p>
	<p class="footnote"><a href="#fn14" name="f14">*14</a>: ほ</p>
	<p class="footnote"><a href="#fn15" name="f15">*15</a>: ぢ</p>
	<p class="footnote"><a href="#fn16" name="f16">*16</a>: づ</p>
	<p class="footnote"><a href="#fn17" name="f17">*17</a>: で</p>
	<p class="footnote"><a href="#fn18" name="f18">*18</a>: ど</p>
	<p class="footnote"><a href="#fn19" name="f19">*19</a>: ば</p>
	<p class="footnote"><a href="#fn20" name="f20">*20</a>: び</p>
	<p class="footnote"><a href="#fn21" name="f21">*21</a>: ぶ</p>
	<p class="footnote"><a href="#fn22" name="f22">*22</a>: べ</p>
	<p class="footnote"><a href="#fn23" name="f23">*23</a>: ぼ</p>
	<p class="footnote"><a href="#fn24" name="f24">*24</a>: ぱ</p>
	<p class="footnote"><a href="#fn25" name="f25">*25</a>: ぴ</p>
	<p class="footnote"><a href="#fn26" name="f26">*26</a>: ぷ</p>
	<p class="footnote"><a href="#fn27" name="f27">*27</a>: ぺ</p>
	<p class="footnote"><a href="#fn28" name="f28">*28</a>: ぽ</p>
</div>
