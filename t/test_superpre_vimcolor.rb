require "t/test_helper"
require "text/hatena"

class TextHatenaSuperpreVimColorTest < Test::Base
  filters %w(.chomp)
  filters :in => 'hatenaize'
  delimitors '###', '@@@'
  run_equal :out, :in

  def hatenaize(value)
    parser = Text::Hatena.new
    parser.parse(value)
    parser.html
  end
end

__END__
### 1
@@@ in
>||
||<
@@@ out
<div class="section">
	<pre class="hatena-super-pre">
</pre>
</div>

### 2
@@@ in
>||
はてな
||<
@@@ out
<div class="section">
	<pre class="hatena-super-pre">
はてな
</pre>
</div>

### 2
@@@ in
>||
int main(int argc, char *argv[])
{
  printf("はてな");
  return 0;
}
||<
@@@ out
<div class="section">
	<pre class="hatena-super-pre">
int main(int argc, char *argv[])
{
  printf(&quot;はてな&quot;);
  return 0;
}
</pre>
</div>

### 3
@@@ in
>|c|
int main(int argc, char *argv[])
{
  printf("はてな");
  return 0;
}
||<
@@@ out
<div class="section">
	<pre class="hatena-super-pre">
<span class="synType">int</span> main(<span class="synType">int</span> argc, <span class="synType">char</span> *argv[])
{
  printf(<span class="synConstant">&quot;はてな&quot;</span>);
  <span class="synStatement">return</span> <span class="synConstant">0</span>;
}
</pre>
</div>

### 4
@@@ in
>|ruby|
if a < b
  puts("こんにちは。")
end
||<
@@@ out
<div class="section">
	<pre class="hatena-super-pre">
<span class="synStatement">if</span><span class="synrubyConditionalExpression"> a &lt; b</span>
<span class="synrubyConditionalExpression">  puts(</span><span class="synSpecial">&quot;</span><span class="synConstant">こんにちは。</span><span class="synSpecial">&quot;</span><span class="synrubyConditionalExpression">)</span>
<span class="synStatement">end</span>
</pre>
</div>
