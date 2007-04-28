require 't/test_helper'
require 'text/hatena/auto_link/hatena_rss'

class TextHatenaAutoLinkHatenaRssTest < Test::Base
  filters :i => %w(hatenaize)
  run_equal :o, :i

  def setup
    @t = Text::Hatena::AutoLink::HatenaRSS.new({:a_target => '_blank'})
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
Here is my reader. r:id:jkondo
--- o
Here is my reader. <a href="http://r.hatena.ne.jp/jkondo/" target="_blank">r:id:jkondo</a>
