require "#{File.dirname(__FILE__)}/../test_helper"

class DynamicTest < Test::Unit::TestCase
  DynamicSegment = Routing::Segments::Dynamic

  def test_create_controller_dynamic_segment
    segment = DynamicSegment.create_for_requirements(":controller")
    assert_equal ":controller", segment.to_s
    assert_equal :controller, segment.to_sym
    assert_equal '":controller"', segment.inspect

    assert_equal true, segment.match!("people")
  end

  def test_create_id_dynamic_segment_with_requirements
    segment = DynamicSegment.create_for_requirements(":id", { :id => /[0-9]+/ })
    assert_equal ":id", segment.to_s
    assert_equal :id, segment.to_sym
    assert_equal '":id (/[0-9]+/)"', segment.inspect

    assert_equal true, segment.match!("1")
    assert_equal false, segment.match!("edit")
  end

  def test_does_eql_other_segment
    s1 = DynamicSegment.create_for_requirements(":controller")
    s2 = DynamicSegment.create_for_requirements(":controller")
    assert_equal true, s1.eql?(s2)
    assert_equal true, s2.eql?(s1)

    s1 = DynamicSegment.create_for_requirements(":id", { :id => /[0-9]+/ })
    s2 = DynamicSegment.create_for_requirements(":id", { :id => /[0-9]+/ })
    assert_equal true, s1.eql?(s2)
    assert_equal true, s2.eql?(s1)
  end

  def test_does_not_eql_other_segment
    s1 = DynamicSegment.create_for_requirements(":controller")
    s2 = DynamicSegment.create_for_requirements(":id")
    assert_equal false, s1.eql?(s2)
    assert_equal false, s2.eql?(s1)
  end
end
