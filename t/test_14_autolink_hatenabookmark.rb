require 't/test_helper'
require 'text/hatena/auto_link/hatena_bookmark'

class TextHatenaAutoLinkHatenaBookmarkTest < Test::Base
  filters :i => %w(hatenaize)
  run_equal :o, :i

  def setup
    @t = Text::Hatena::AutoLink::HatenaBookmark.new({:a_target => '_blank'})
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
Entries about Perl. [b:keyword:Perl]
--- o
Entries about Perl. <a href="http://b.hatena.ne.jp/keyword/Perl" target="_blank">b:keyword:Perl</a>

===
--- i
Entries about Perl. [b:t:Perl]
--- o
Entries about Perl. <a href="http://b.hatena.ne.jp/t/Perl" target="_blank">b:t:Perl</a>

===
--- i
Here is my bookmark. b:id:jkondo
--- o
Here is my bookmark. <a href="http://b.hatena.ne.jp/jkondo/" target="_blank">b:id:jkondo</a>

===
--- i
Here is my favorite. b:id:jkondo:favorite
--- o
Here is my favorite. <a href="http://b.hatena.ne.jp/jkondo/favorite" target="_blank">b:id:jkondo:favorite</a>

===
--- i
Here is my favorite books. b:id:jkondo:asin
--- o
Here is my favorite books. <a href="http://b.hatena.ne.jp/jkondo/asin" target="_blank">b:id:jkondo:asin</a>

===
--- i
Here is my perl bookmarks. [b:id:jkondo:t:perl]
--- o
Here is my perl bookmarks. <a href="http://b.hatena.ne.jp/jkondo/perl/" target="_blank">b:id:jkondo:t:perl</a>
