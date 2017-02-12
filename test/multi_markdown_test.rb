# encoding: UTF-8
require 'test_helper'

class MultimarkdownTest < Test::Unit::TestCase
  def test_simple_one_liner_to_html
    multimarkdown = Multimarkdown.new('Hello World.')
    assert_respond_to multimarkdown, :to_html
    assert_equal "<p>Hello World.</p>", multimarkdown.to_html.strip
  end

  def test_inline_Multimarkdown_to_html
    multimarkdown = Multimarkdown.new('_Hello World_!')
    assert_respond_to multimarkdown, :to_html
    assert_equal "<p><em>Hello World</em>!</p>", multimarkdown.to_html.strip
  end

  def test_Multimarkdown_in_html_to_html
    multimarkdown = Multimarkdown.new('Hello <span>_World_</span>!',:process_html)
    assert_respond_to multimarkdown, :to_html
    assert_equal "<p>Hello <span><em>World</em></span>!</p>", multimarkdown.to_html.strip
  end

  def test_version_fits
    assert Multimarkdown::VERSION =~ /^#{Multimarkdown::MMD_VERSION}/,
      "Expected Multimarkdown's version (#{Multimarkdown::VERSION}) to start with the C library's version (#{Multimarkdown::MMD_VERSION})"
  end

  def test_meta_attributes
    multimarkdown = Multimarkdown.new(<<-eof)
meta1: Foo
meta2: Bar

Lorem Ipsum
    eof
    assert_equal ["meta1", "meta2"], multimarkdown.metadata_keys()

    assert_equal "Foo", multimarkdown.metadata_value("Meta1")
    assert_equal "Bar", multimarkdown.metadata_value("Meta2")
  end

  def test_cached_metadata
    multimarkdown = Multimarkdown.new(<<-eof)
MetaTheMeta1: Foo
MetaTheMeta2: Bar

Lorem Ipsum
    eof

    assert_equal( { "metathemeta1" => "Foo", "metathemeta2" => "Bar" },
      multimarkdown.metadata)

    assert_equal("Foo", multimarkdown.metadata("MetaTheMeta1"))
    assert_equal(nil, multimarkdown.metadata["MetaTheMeta1"])
  end

  def test_encoding
      multimarkdown = Multimarkdown.new(<<-eof)
umlauts: M€tädätä

ÄÖÜßäöüµ√
=========

eof
      assert_match(/<h1[^>]*>ÄÖÜßäöüµ√<\/h1>/, multimarkdown.to_html.strip)
      assert_equal("M€tädätä", multimarkdown.metadata('umlauts'))
  end
end
