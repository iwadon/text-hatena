require 't/test_helper'
require 'text/hatena/auto_link/hatena_question'

class TextHatenaAutoLinkHatenaQuestionTest < Test::Base
  filters :i => %w(hatenaize)
  run_equal :o, :i

  def setup
    @t = Text::Hatena::AutoLink::HatenaQuestion.new({:a_target => '_blank'})
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
My question history. q:id:jkondo
--- o
My question history. <a href="http://q.hatena.ne.jp/jkondo/" target="_blank">q:id:jkondo</a>

===
--- i
The first question. question:995116699
--- o
The first question. <a href="http://q.hatena.ne.jp/995116699" target="_blank">question:995116699</a>
