require "#{File.dirname(__FILE__)}/../test_helper"

class LeafTest < Test::Unit::TestCase
  LeafSegment = Routing::Segments::Leaf

  def test_split_into_plain_segments
    assert_equal ["/"], LeafSegment.split_into_plain_segments("/")
    assert_equal ["/", "people"], LeafSegment.split_into_plain_segments("/people")
    assert_equal ["/", "people", "/", "show", "/", "1"], LeafSegment.split_into_plain_segments("/people/show/1")
    assert_equal ["/", "people", "/", "edit", "/", "1"], LeafSegment.split_into_plain_segments("/people/edit/1")
  end

  def test_inspect
    segment = LeafSegment.new("/people", :controller => "people", :action => "index")
    assert_equal "PeopleController#index", segment.to_s
  end

  def test_method
    assert_equal :any,
      LeafSegment.new("/people",
        :controller => "people",
        :action => "index"
      ).method

    assert_equal :get,
      LeafSegment.new("/people",
        :controller => "people",
        :action => "index",
        :conditions => { :method => :get }
      ).method
  end

  def test_significant_keys
    s = LeafSegment.new("/:controller/:action/:id")
    assert_equal [:controller, :action, :id], s.significant_keys

    s = LeafSegment.new("/people", :controller => "people", :action => "index", :conditions => { :method => :get })
    assert_equal [:controller, :action], s.significant_keys
  end

  def test_match
    segment = LeafSegment.new("/people/show/:id", :controller => "people", :action => "show")
    assert_equal true, segment.match!(nil)
    assert_equal false, segment.match!(false)
  end

  def test_walk
    segment = LeafSegment.new("/people/show/:id", :controller => "people", :action => "show")
    assert_equal({:controller => "people", :id => "1", :action => "show"}, segment.walk(["/", "people", "/", "show", "/", "1"], 5))
  end

  def test_does_eql_other_segment
    s1 = LeafSegment.new("/people/show/:id", :controller => "people", :action => "show")
    s2 = LeafSegment.new("/people/show/:id", :controller => "people", :action => "show")
    assert_equal true, s1.eql?(s2)
    assert_equal true, s2.eql?(s1)
  end

  def test_does_not_eql_other_segment
    s1 = LeafSegment.new("/people/show/:id", :controller => "people", :action => "show")
    s2 = LeafSegment.new("/people/edit/:id", :controller => "people", :action => "edit")
    assert_equal false, s1.eql?(s2)
    assert_equal false, s2.eql?(s1)
  end

  def test_extract_params
    s = LeafSegment.new("/people", :controller => "people", :action => "index")
    assert_equal({ :controller => "people", :action => "index" }, s.extract_params(["/", "people"]))

    s = LeafSegment.new("/people/show/:id", :controller => "people", :action => "show")
    assert_equal({ :controller => "people", :action => "show", :id => "1" }, s.extract_params(["/", "people", "/", "show", "/", "1"]))

    s = LeafSegment.new("/:controller/:action/:id")
    assert_equal({ :controller => "people", :action => "show", :id => "1" }, s.extract_params(["/", "people", "/", "show", "/", "1"]))
  end
end
