require 't/test_helper'
require 'text/hatena/auto_link/tex'

class TextHatenaAutoLinkTexTest < Test::Base
  filters :i => %w(hatenaize)
  run_equal :o, :i

  def setup
    @t = Text::Hatena::AutoLink::Tex.new
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
formula [tex:x^2+y^2=z^2]
--- o
formula <img src="http://d.hatena.ne.jp/cgi-bin/mimetex.cgi?x^2+y^2=z^2" class="tex" alt="x^2+y^2=z^2">

===
--- i
[tex:(2+(2*2))=6]
--- o
<img src="http://d.hatena.ne.jp/cgi-bin/mimetex.cgi?(2+(2*2))=6" class="tex" alt="(2+(2*2))=6">
