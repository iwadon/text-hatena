require 't/test_helper'
require 'text/hatena/auto_link/hatena_antenna'

class TextHatenaAutoLinkHatenaAntennaTest < Test::Base
  filters :i => %w(hatenaize)
  run_equal :o, :i

  def setup
    @t = Text::Hatena::AutoLink::HatenaAntenna.new
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
Here is my antenna. a:id:jkondo
--- o
Here is my antenna. <a href="http://a.hatena.ne.jp/jkondo/">a:id:jkondo</a>
