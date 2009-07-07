--- !ruby/object:Gem::Specification 
name: text-hatena
version: !ruby/object:Gem::Version 
  version: 0.12.20080627.0
platform: ruby
authors: 
- Hiroyuki Iwatsuki
autorequire: 
bindir: bin
cert_chain: []

date: 2009-07-07 00:00:00 +09:00
default_executable: 
dependencies: []

description: 
email: don@na.rim.or.jp
executables: []

extensions: []

extra_rdoc_files: []

files: 
- README
- README.en
- README.rdoc
- Rakefile
- lib/text/hatena.rb
- lib/text/hatena/auto_link.rb
- lib/text/hatena/auto_link/amazon.rb
- lib/text/hatena/auto_link/asin.rb
- lib/text/hatena/auto_link/ean.rb
- lib/text/hatena/auto_link/ftp.rb
- lib/text/hatena/auto_link/google.rb
- lib/text/hatena/auto_link/hatena_antenna.rb
- lib/text/hatena/auto_link/hatena_bookmark.rb
- lib/text/hatena/auto_link/hatena_diary.rb
- lib/text/hatena/auto_link/hatena_fotolife.rb
- lib/text/hatena/auto_link/hatena_graph.rb
- lib/text/hatena/auto_link/hatena_group.rb
- lib/text/hatena/auto_link/hatena_id.rb
- lib/text/hatena/auto_link/hatena_idea.rb
- lib/text/hatena/auto_link/hatena_map.rb
- lib/text/hatena/auto_link/hatena_question.rb
- lib/text/hatena/auto_link/hatena_rss.rb
- lib/text/hatena/auto_link/hatena_search.rb
- lib/text/hatena/auto_link/http.rb
- lib/text/hatena/auto_link/mailto.rb
- lib/text/hatena/auto_link/rakuten.rb
- lib/text/hatena/auto_link/scheme.rb
- lib/text/hatena/auto_link/tex.rb
- lib/text/hatena/auto_link/unbracket.rb
- lib/text/hatena/blockquote_node.rb
- lib/text/hatena/body_node.rb
- lib/text/hatena/br_node.rb
- lib/text/hatena/cdata_node.rb
- lib/text/hatena/context.rb
- lib/text/hatena/dl_node.rb
- lib/text/hatena/footnote_node.rb
- lib/text/hatena/h3_node.rb
- lib/text/hatena/h4_node.rb
- lib/text/hatena/h5_node.rb
- lib/text/hatena/html_filter.rb
- lib/text/hatena/list_node.rb
- lib/text/hatena/node.rb
- lib/text/hatena/p_node.rb
- lib/text/hatena/pre_node.rb
- lib/text/hatena/section_node.rb
- lib/text/hatena/superpre_node.rb
- lib/text/hatena/table_node.rb
- lib/text/hatena/tag_node.rb
- lib/text/hatena/tagline_node.rb
- lib/text/hatena/text.rb
- lib/text/hatena/utils/htmlsplit.rb
- lib/text/hatena/utils/section_node_utils.rb
- t/test_02_autolink_text.rb
- t/test_06_autolink_hatenafotolife.rb
- t/test_08_autolink_asin.rb
- t/test_09_autolink_hatenadiary.rb
- t/test_11_autolink_tex.rb
- t/test_13_autolink_hatenaantenna.rb
- t/test_14_autolink_hatenabookmark.rb
- t/test_15_autolink_hatenarss.rb
- t/test_16_autolink_hatenaidea.rb
- t/test_17_autolink_hatenaquestion.rb
- t/test_18_autolink_ean.rb
- t/test_19_autolink_hatenagraph.rb
- t/test_23_autolink_amazon.rb
- t/test_asin.rb
- t/test_auto_link.rb
- t/test_dl_node.rb
- t/test_erb_tag.rb
- t/test_footnote.rb
- t/test_footnote_in_list.rb
- t/test_helper.rb
- t/test_quote.rb
- t/test_raw_html.rb
- t/test_sanitize.rb
- t/test_superpre_vimcolor.rb
- t/test_text_hatena.rb
- t/test_text_hatena_autolink.rb
- text-hatena.gemspec
has_rdoc: true
homepage: http://moonrock.jp/~don/ruby/text-hatena/
licenses: []

post_install_message: 
rdoc_options: []

require_paths: 
- lib
required_ruby_version: !ruby/object:Gem::Requirement 
  requirements: 
  - - ">="
    - !ruby/object:Gem::Version 
      version: "0"
  version: 
required_rubygems_version: !ruby/object:Gem::Requirement 
  requirements: 
  - - ">="
    - !ruby/object:Gem::Version 
      version: "0"
  version: 
requirements: []

rubyforge_project: 
rubygems_version: 1.3.4
signing_key: 
specification_version: 3
summary: A Ruby library for Hatena notation
test_files: []

