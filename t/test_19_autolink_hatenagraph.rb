require 't/test_helper'
require 'text/hatena/auto_link/hatena_graph'

class TextHatenaAutoLinkHatenaGraphTest < Test::Base
  filters :i => %w(hatenaize)
  run_equal :o, :i

  def setup
    @t = Text::Hatena::AutoLink::HatenaGraph.new({:a_target => '_blank'})
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
Weight graphs [graph:t:Kg]
--- o
Weight graphs <a href="http://graph.hatena.ne.jp/t/Kg" target="_blank">graph:t:Kg</a>

===
--- i
My weight. [graph:id:jkondo:体重:image]
--- o
My weight. <a href="http://graph.hatena.ne.jp/jkondo/%e4%bd%93%e9%87%8d/" target="_blank"><img src="http://graph.hatena.ne.jp/jkondo/graph?graphname=%e4%bd%93%e9%87%8d" class="hatena-graph-image" alt="体重" title="体重"></a>

===
--- i
My weight. [graph:id:jkondo:体重]
--- o
My weight. <a href="http://graph.hatena.ne.jp/jkondo/%e4%bd%93%e9%87%8d/" target="_blank">graph:id:jkondo:体重</a>

===
--- i
My graphs graph:id:jkondo
--- o
My graphs <a href="http://graph.hatena.ne.jp/jkondo/" target="_blank">graph:id:jkondo</a>
