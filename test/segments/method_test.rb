require "#{File.dirname(__FILE__)}/../test_helper"

class MethodTest < Test::Unit::TestCase
  MethodSegment = Routing::Segments::Method

  def test_create_helper
    segment = MethodSegment.create(:post).first
    assert_equal "POST", segment.to_s
    assert_equal :post, segment.to_sym

    segment = MethodSegment.create(:any).first
    assert_equal "GET", segment.to_s
    assert_equal :get, segment.to_sym
  end

  def test_cannot_create_a_segment_from_an_invalid_method
    assert_raise(ArgumentError) { MethodSegment.new("FOO") }
  end

  def test_does_eql_other_segment
    s1 = MethodSegment.new(:get)
    s2 = MethodSegment.new(:get)
    assert_equal true, s1.eql?(s2)
    assert_equal true, s2.eql?(s1)
  end

  def test_does_not_eql_other_segment
    s1 = MethodSegment.new(:get)
    s2 = MethodSegment.new(:post)
    assert_equal false, s1.eql?(s2)
    assert_equal false, s2.eql?(s1)
  end

  def test_match
    segment = MethodSegment.new(:get)
    segment =~ "GET"
  end
end
