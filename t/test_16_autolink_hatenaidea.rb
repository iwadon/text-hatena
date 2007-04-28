require 't/test_helper'
require 'text/hatena/auto_link/hatena_idea'

class TextHatenaAutoLinkHatenaIdeaTest < Test::Base
  filters :i => %w(hatenaize)
  run_equal :o, :i

  def setup
    @t = Text::Hatena::AutoLink::HatenaIdea.new({:a_target => '_blank'})
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
My Idea Stocks. i:id:jkondo
--- o
My Idea Stocks. <a href="http://i.hatena.ne.jp/jkondo/" target="_blank">i:id:jkondo</a>

===
--- i
Ideas about podcast. [i:t:podcast]
--- o
Ideas about podcast. <a href="http://i.hatena.ne.jp/t/podcast" target="_blank">i:t:podcast</a>

===
--- i
idea:2669 can be made with Text::Hatena
--- o
<a href="http://i.hatena.ne.jp/idea/2669" target="_blank">idea:2669</a> can be made with Text::Hatena
