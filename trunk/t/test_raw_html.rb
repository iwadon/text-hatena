require "t/test_helper"
require "text/hatena/auto_link"

class RawHTMLTest < Test::Base
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
<code>はてな</code>
<strong>はてな</strong>
--- out
<div class="section">
	<p><code>はてな</code></p>
	<p><strong>はてな</strong></p>
</div>
