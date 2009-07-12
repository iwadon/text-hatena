require 't/test_helper'
require 'text/hatena/auto_link/hatena_fotolife'

class TextHatenaAutoLinkHatenaFotolifeTest < Test::Base
  run_equal :o, :i

  def hatenaize(value)
    t = Text::Hatena::AutoLink::HatenaFotolife.new
    value.gsub(t.pattern) do
      t.parse($&)
    end
  end

  def hatenaize_blank(value)
    t = Text::Hatena::AutoLink::HatenaFotolife.new({:a_target => '_blank'})
    value.gsub(t.pattern) do
      t.parse($&)
    end
  end
end

__END__

=== HatenaFotolife 1
--- i hatenaize
Here is my album. f:id:jkondo
--- o
Here is my album. <a href="http://f.hatena.ne.jp/jkondo/">f:id:jkondo</a>

=== HatenaFotolife 2
--- i hatenaize_blank
Here is my favorite. f:id:sample:favorite
--- o
Here is my favorite. <a href="http://f.hatena.ne.jp/sample/favorite" target="_blank">f:id:sample:favorite</a>

=== HatenaFotolife 3
--- i hatenaize_blank
Yukidaruma. f:id:jkondo:20060121153528j:image
--- o
Yukidaruma. <a href="http://f.hatena.ne.jp/jkondo/20060121153528" target="_blank"><img src="http://f.hatena.ne.jp/images/fotolife/j/jkondo/20060121/20060121153528.jpg" alt="f:id:jkondo:20060121153528j:image" title="f:id:jkondo:20060121153528j:image" class="hatena-fotolife"></a>

=== HatenaFotolife 4
--- i hatenaize_blank
Sky photos. [f:t:空]
--- o
Sky photos. <a href="http://f.hatena.ne.jp/t/%e7%a9%ba" target="_blank">f:t:空</a>

=== HatenaFotolife 5
--- i hatenaize_blank
Cinnamon photos. [f:keyword:しなもん]
--- o
Cinnamon photos. <a href="http://f.hatena.ne.jp/keyword/%e3%81%97%e3%81%aa%e3%82%82%e3%82%93" target="_blank">f:keyword:しなもん</a>

=== HatenaFotolife :image:small
--- i hatenaize_blank
Yukidaruma. f:id:jkondo:20060121153528j:image:small
--- o
Yukidaruma. <a href="http://f.hatena.ne.jp/jkondo/20060121153528" target="_blank"><img src="http://f.hatena.ne.jp/images/fotolife/j/jkondo/20060121/20060121153528_m.gif" alt="f:id:jkondo:20060121153528j:image:small" title="f:id:jkondo:20060121153528j:image:small" class="hatena-fotolife"></a>

=== HatenaFotolife :image:medium
--- i hatenaize_blank
Yukidaruma. f:id:jkondo:20060121153528j:image:medium
--- o
Yukidaruma. <a href="http://f.hatena.ne.jp/jkondo/20060121153528" target="_blank"><img src="http://f.hatena.ne.jp/images/fotolife/j/jkondo/20060121/20060121153528_120.jpg" alt="f:id:jkondo:20060121153528j:image:medium" title="f:id:jkondo:20060121153528j:image:medium" class="hatena-fotolife"></a>

=== HatenaFotolife :image:w50
--- i hatenaize_blank
Yukidaruma. f:id:jkondo:20060121153528j:image:w50
--- o
Yukidaruma. <a href="http://f.hatena.ne.jp/jkondo/20060121153528" target="_blank"><img src="http://f.hatena.ne.jp/images/fotolife/j/jkondo/20060121/20060121153528.jpg" alt="f:id:jkondo:20060121153528j:image:w50" title="f:id:jkondo:20060121153528j:image:w50" class="hatena-fotolife" width="50"></a>

=== HatenaFotolife :image:h50
--- i hatenaize_blank
Yukidaruma. f:id:jkondo:20060121153528j:image:h50
--- o
Yukidaruma. <a href="http://f.hatena.ne.jp/jkondo/20060121153528" target="_blank"><img src="http://f.hatena.ne.jp/images/fotolife/j/jkondo/20060121/20060121153528.jpg" alt="f:id:jkondo:20060121153528j:image:h50" title="f:id:jkondo:20060121153528j:image:h50" class="hatena-fotolife" height="50"></a>

=== HatenaFotolife :image:left
--- i hatenaize_blank
Yukidaruma. f:id:jkondo:20060121153528j:image:left
--- o
Yukidaruma. <a href="http://f.hatena.ne.jp/jkondo/20060121153528" target="_blank"><img src="http://f.hatena.ne.jp/images/fotolife/j/jkondo/20060121/20060121153528.jpg" alt="f:id:jkondo:20060121153528j:image:left" title="f:id:jkondo:20060121153528j:image:left" class="hatena-fotolife hatena-image-left"></a>

=== HatenaFotolife :image:right
--- i hatenaize_blank
Yukidaruma. f:id:jkondo:20060121153528j:image:right
--- o
Yukidaruma. <a href="http://f.hatena.ne.jp/jkondo/20060121153528" target="_blank"><img src="http://f.hatena.ne.jp/images/fotolife/j/jkondo/20060121/20060121153528.jpg" alt="f:id:jkondo:20060121153528j:image:right" title="f:id:jkondo:20060121153528j:image:right" class="hatena-fotolife hatena-image-right"></a>

=== HatenaFotolife :image:w90,h67,right
--- i hatenaize_blank
Yukidaruma. f:id:jkondo:20060121153528j:image:w90,h67,right
--- o
Yukidaruma. <a href="http://f.hatena.ne.jp/jkondo/20060121153528" target="_blank"><img src="http://f.hatena.ne.jp/images/fotolife/j/jkondo/20060121/20060121153528.jpg" alt="f:id:jkondo:20060121153528j:image:w90,h67,right" title="f:id:jkondo:20060121153528j:image:w90,h67,right" class="hatena-fotolife hatena-image-right" width="90" height="67"></a>

=== HatenaFotolife :movie
--- SKIP i hatenaize_blank
[f:id:hatenafotolife:20081030172138f:movie]
--- o
<object data="http://f.hatena.ne.jp/tools/flvplayer_s.swf" type="application/x-shockwave-flash" width="320" height="276">
<param name="movie" value="http://f.hatena.ne.jp/tools/flvplayer_s.swf"></param>
<param name="FlashVars" value="fotoid=20081030172138&user=hatenafotolife"></param>
<param name="wmode" value="transparent"></param>
</object>
