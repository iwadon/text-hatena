require 't/test_helper'
require 'text/hatena/auto_link/ean'

class TextHatenaAutoLinkEanTest < Test::Base
  filters :i => %w(hatenaize)
  run_equal :o, :i

  def setup
    @t = Text::Hatena::AutoLink::EAN.new({:a_target => '_blank'})
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
Jagariko ean:4901330571870
--- o
Jagariko <a href="http://d.hatena.ne.jp/ean/4901330571870" target="_blank">ean:4901330571870</a>

===
--- i
Jagariko [ean:4901330571870:title=jagariko]
--- o
Jagariko <a href="http://d.hatena.ne.jp/ean/4901330571870" target="_blank">jagariko</a>
