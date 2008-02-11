require 't/test_helper'
require 'text/hatena/auto_link/hatena_diary'

class TextHatenaAutoLinkHatenaDiaryTest < Test::Base
  filters :i => %w(hatenaize)
  run_equal :o, :i

  def setup
    @t = Text::Hatena::AutoLink::HatenaDiary.new({:a_target => '_blank'})
    @pat = @t.pattern
  end

  def hatenaize(value)
    value.gsub(@pat) do
      @t.parse($&)
    end
  end
end

__END__

===
--- i
My Blog is d:id:jkondo.
--- o
My Blog is <a href="http://d.hatena.ne.jp/jkondo/" target="_blank">d:id:jkondo</a>.

===
--- i
Today's entry. d:id:jkondo:20060124.
--- o
Today's entry. <a href="http://d.hatena.ne.jp/jkondo/20060124" target="_blank">d:id:jkondo:20060124</a>.

===
--- i
Today's entry. d:id:jkondo:20060124:1138066304.
--- o
Today's entry. <a href="http://d.hatena.ne.jp/jkondo/20060124/1138066304" target="_blank">d:id:jkondo:20060124:1138066304</a>.

===
--- i
My profile is here. d:id:jkondo:about
--- o
My profile is here. <a href="http://d.hatena.ne.jp/jkondo/about" target="_blank">d:id:jkondo:about</a>

===
--- i
My archive is here. d:id:jkondo:archive
--- o
My archive is here. <a href="http://d.hatena.ne.jp/jkondo/archive" target="_blank">d:id:jkondo:archive</a>

===
--- i
My archive is here. d:id:jkondo:archive:200601
--- o
My archive is here. <a href="http://d.hatena.ne.jp/jkondo/archive/200601" target="_blank">d:id:jkondo:archive:200601</a>

===
--- i
see [d:keyword:はてな] for detailed info.
--- o
see <a href="http://d.hatena.ne.jp/keyword/%a4%cf%a4%c6%a4%ca" target="_blank">d:keyword:はてな</a> for detailed info.
