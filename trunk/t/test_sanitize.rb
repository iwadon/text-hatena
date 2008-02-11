require "t/test_helper"
require "text/hatena/auto_link"

class SanitizeTest < Test::Base
  filters %w(.chomp)
  filters :in => 'hatenaize'
  run_equal :out, :in

  def hatenaize(value)
    parser = Text::Hatena.new({ :baseuri => 'http://d.hatena.ne.jp/jkondo',
                                :permalink => 'http://d.hatena.ne.jp/jkondo/20050906',
                                :ilevel => 0,
                                :ivalidnode => [],
                                :sectionanchor => 'sa' })
    parser.parse(value)
    parser.html
  end
end

__END__
===
--- in
<script lang="text/javascript">alert();</script><foo><div foo="bar">hoge</div>
--- out
<div class="section">
	<p>&lt;script lang="text/javascript"&gt;alert();&lt;/script&gt;&lt;foo&gt;<div>hoge</div></p>
</div>
