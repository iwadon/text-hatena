# -*- mode: ruby; coding: utf-8 -*-
require "t/test_helper"
require "text/hatena/auto_link/amazon"

class TextHatenaAutoLinkAmazonTest < Test::Base
  filters :i => %w(hatenaize)
  run_equal :o, :i

  def setup
    @t = Text::Hatena::AutoLink::Amazon.new({:a_target => '_blank'})
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
--- in
Hatena books. [amazon:はてな]
--- out
Hatena books. <a href="http://www.amazon.co.jp/exec/obidos/external-search?mode=blended&tag=hatena-22&encoding-string-jp=%e6%97%a5%e6%9c%ac%e8%aa%9e&keyword=%e3%81%af%e3%81%a6%e3%81%aa" target="_blank">amazon:はてな</a>
