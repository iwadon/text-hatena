require "t/test_helper"
require "text/hatena/auto_link"

class ErbTagTest < Test::Base
  filters %w(.chomp)
  filters :in => 'hatenaize'
  run_equal :out, :in

  def hatenaize(value)
    parser = Text::Hatena.new
    parser.parse(value)
    parser.html
  end
end

__END__
===
--- in
<% はてな %>
--- out
<div class="section">
	<p>&lt;% はてな %&gt;</p>
</div>
