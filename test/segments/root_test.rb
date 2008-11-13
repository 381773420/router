require "#{File.dirname(__FILE__)}/../test_helper"

class RootTest < Test::Unit::TestCase
  RootSegment = Routing::Segments::Root

  def test_root_segments_never_match
    s1 = RootSegment.new
    s2 = RootSegment.new
    assert_equal false, s1.eql?(s2)
    assert_equal false, s2.eql?(s1)
  end

  def test_match
    segment = RootSegment.new
    assert_raise(ArgumentError) { segment.match!(nil) }
  end
end
