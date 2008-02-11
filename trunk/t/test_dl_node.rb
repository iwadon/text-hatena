require "t/test_helper"
require "text/hatena"

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
:12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
--- out
<div class="section">
	<p>:12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890</p>
</div>
