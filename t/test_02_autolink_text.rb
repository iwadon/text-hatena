require 't/test_helper'
require 'text/hatena/auto_link'

class TextHatenaAutoLinkTextTest < Test::Base
  filters :o => %w(hatenaize)
  run_equal :o, :i

  def hatenaize(value)
    t = Text::Hatena::AutoLink.new
    t.parse(value)
  end
end

__END__

=== 02_autolink_text.t
--- i
Hi, this is a simple text.
--- o
Hi, this is a simple text.
