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
Yukidaruma. <a href="http://f.hatena.ne.jp/jkondo/20060121153528" target="_blank"><img src="http://f.hatena.ne.jp/images/fotolife/j/jkondo/20060121/20060121153528.jpg" alt="f:id:jkondo:20060121153528j:image" title="f:id:jkondo:20060121153528j:image"></a>

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
