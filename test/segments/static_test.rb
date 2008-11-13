require "#{File.dirname(__FILE__)}/../test_helper"

class StaticTest < Test::Unit::TestCase
  StaticSegment = Routing::Segments::Static

  def test_does_eql_other_segment
    s1 = StaticSegment.new("people")
    s2 = StaticSegment.new("people")
    assert_equal true, s1.eql?(s2)
    assert_equal true, s2.eql?(s1)
  end

  def test_does_not_eql_other_segment
    s1 = StaticSegment.new("people")
    s2 = StaticSegment.new("posts")
    assert_equal false, s1.eql?(s2)
    assert_equal false, s2.eql?(s1)
  end

  def test_match
    segment = StaticSegment.new("people")
    assert_equal true, segment.match!("people")
  end
end
