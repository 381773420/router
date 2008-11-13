require "#{File.dirname(__FILE__)}/../test_helper"

class SeparatorTest < Test::Unit::TestCase
  SeparatorSegment = Routing::Segments::Separator

  def test_cannot_create_a_segment_from_an_invalid_character
    assert_raise(ArgumentError) { SeparatorSegment.new("!") }
  end

  def test_does_eql_other_segment
    s1 = SeparatorSegment.new("/")
    s2 = SeparatorSegment.new("/")
    assert_equal true, s1.eql?(s2)
    assert_equal true, s2.eql?(s1)
  end

  def test_does_not_eql_other_segment
    s1 = SeparatorSegment.new("/")
    s2 = SeparatorSegment.new(".")
    assert_equal false, s1.eql?(s2)
    assert_equal false, s2.eql?(s1)
  end

  def test_match
    segment = SeparatorSegment.new("/")
    assert_equal true, segment =~ "/"
  end
end
