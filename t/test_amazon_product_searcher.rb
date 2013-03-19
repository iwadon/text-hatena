# -*- coding: utf-8 -*-

$:.unshift(File.dirname(__FILE__) + '/../lib')
require "text/hatena/utils/amazon_product_searcher"
require "test/unit"

class AmazonProductSearcherTest < Test::Unit::TestCase
  def test_lookup
    searcher = Text::Hatena::AmazonProductSearcher.new
    item = searcher.lookup("B0013E13Y4")
    assert_instance_of Text::Hatena::AmazonProductSearcher::Item, item
  end
end

class AmazonProductSearcherItemTest < Test::Unit::TestCase
  def setup
    @searcher = Text::Hatena::AmazonProductSearcher.new
  end

  def test_title
    item = @searcher.lookup("B0013E13Y4")
    assert_equal 'オメガファイブ サウンドトラック', item.title
  end

  def test_small_image
    item = @searcher.lookup("B0013E13Y4")
    img = item.small_image
    assert_equal 'http://ecx.images-amazon.com/images/I/61WtqrZRMzL._SL75_.jpg', img.url
  end

  def test_medium_image
    item = @searcher.lookup("B0013E13Y4")
    img = item.medium_image
    assert_equal 'http://ecx.images-amazon.com/images/I/61WtqrZRMzL._SL160_.jpg', img.url
  end

  def test_large_image
    item = @searcher.lookup("B0013E13Y4")
    img = item.large_image
    assert_equal 'http://ecx.images-amazon.com/images/I/61WtqrZRMzL.jpg', img.url
  end

  def test_artist
    item = @searcher.lookup("B0013E13Y4")
    assert_equal 'ゲーム・ミュージック', item.artist
  end

  def test_artists
    item = @searcher.lookup("B00BQVGC3Q")
    assert_equal ["スクリーントーンズ", "久住昌之", "フクムラサトシ", "河野文彦", "Shake", "栗木健", "戸田高弘"], item.artists
  end

  def test_author
    item = @searcher.lookup("4785940107")
    assert_equal '宇河 弘樹', item.author
  end

  def test_authors
    item = @searcher.lookup("4757538758")
    assert_equal ["鎌池 和馬", "近木野 中哉"], item.authors
  end

  def test_manufacturer
    item = @searcher.lookup("B0013E13Y4")
    assert_equal 'SuperSweep', item.manufacturer
  end

  def test_publication_date
    item = @searcher.lookup("4785940107")
    assert_equal '2013-04-30', item.publication_date
  end

  def test_release_date
    item = @searcher.lookup("B0013E13Y4")
    assert_equal '2008-03-19', item.release_date
  end

  def test_binding
    item = @searcher.lookup("B0013E13Y4")
    assert_equal 'CD', item.binding
  end
end
