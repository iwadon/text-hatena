require 't/test_helper'
require 'text/hatena/auto_link/asin'

class TextHatenaAutoLinkAsinTest < Test::Base
  run_equal :o, :i

  def setup
    @options = {}
  end

  def hatenaize(value)
    t = Text::Hatena::AutoLink::ASIN.new
    value.gsub(t.pattern) do
      t.parse($&)
    end
  end

  def hatenaize_blank(value)
    t = Text::Hatena::AutoLink::ASIN.new({:a_target => '_blank'}.merge(@options))
    value.gsub(t.pattern) do
      t.parse($&)
    end
  end

  def affiliate_id(value)
    @options[:scheme_option] = {
      :isbn => {
        :amazon_affiliate_id => 'staffdiaryrei-22',
      }
    }
    value
  end
end

__END__

=== 08_autolink_asin.t 1
--- in hatenaize_blank
Here is my book. ISBN:4798110523
--- out
Here is my book. <a href="http://d.hatena.ne.jp/asin/4798110523" target="_blank">ISBN:4798110523</a>

=== 08_autolink_asin.t 2
--- in hatenaize_blank
Here is my book. ISBN:4798110523:image
--- out
Here is my book. <a href="http://d.hatena.ne.jp/asin/4798110523" target="_blank"><img src="http://ecx.images-amazon.com/images/I/21DMWVBQP5L.jpg" alt="「へんな会社」のつくり方 (NT2X)" title="「へんな会社」のつくり方 (NT2X)" class="asin"></a>

=== 08_autolink_asin.t 3
--- in hatenaize_blank
Here is my book. ISBN:4798110523:title
--- out
Here is my book. <a href="http://d.hatena.ne.jp/asin/4798110523" target="_blank">「へんな会社」のつくり方 (NT2X)</a>

=== 08_autolink_asin.t 4
--- in hatenaize_blank
Here is my book. [ISBN:4798110523:title=How to make a strange company.]
--- out
Here is my book. <a href="http://d.hatena.ne.jp/asin/4798110523" target="_blank">How to make a strange company.</a>

=== 08_autolink_asin.t 5
--- in affiliate_id hatenaize
Here is my book. ISBN:4798110523
--- out
Here is my book. <a href="http://d.hatena.ne.jp/asin/4798110523/staffdiaryrei-22">ISBN:4798110523</a>
