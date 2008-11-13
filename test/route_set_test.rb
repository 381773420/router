require "#{File.dirname(__FILE__)}/test_helper"

class RouteSetTest < Test::Unit::TestCase
  def setup
    @set = Routing::RouteSet.new

    @set.draw do |map|
      map.resources :posts
      map.connect ":token/posts.xml", :controller => "posts", :action => "index", :format => "xml"

      map.resources :people

      map.connect 'session', :controller => "sessions", :action => "create", :conditions => { :method => :get }
      map.connect 'login/authenticate', :controller => "sessions", :action => "create", :conditions => { :method => :get }

      map.connect 'login', :controller => "sessions", :action => "new", :conditions => { :method => :get }
      map.resources :session

      map.connect ':controller/:action/:id'
      map.connect ':controller/:action/:id.:format'
    end
  end

  def test_recognize_path
    assert_equal({
      :controller => "posts",
      :action => "index",
      :conditions => { :method => :get }
    }, @set.recognize_path("GET", "/posts"))

    assert_equal({
      :controller => "posts",
      :action => "create",
      :conditions => { :method => :post }
    }, @set.recognize_path("POST", "/posts"))

    assert_equal({
      :id => "1",
      :controller => "posts",
      :action => "show",
      :conditions => { :method => :get }
    }, @set.recognize_path("GET", "/posts/1"))

    assert_equal({
      :controller => "posts",
      :action => "show",
      :conditions => { :method => :get },
      :id => "1",
      :format => "xml"
    }, @set.recognize_path("GET", "/posts/1.xml"))

    assert_equal({
      :id => "2",
      :controller => "posts",
      :action => "update",
      :conditions => { :method => :put }
    }, @set.recognize_path("PUT", "/posts/2"))

    assert_equal({
      :id => "3",
      :controller => "posts",
      :action => "destroy",
      :conditions => { :method => :delete }
    }, @set.recognize_path("DELETE", "/posts/3"))

    assert_equal({
      :id => "3",
      :action => "show",
      :controller => "people",
      :conditions => { :method => :get }
    }, @set.recognize_path("GET", "/people/3"))

    assert_equal({
      :id => "3",
      :action => "edit",
      :controller => "people",
      :conditions => { :method => :get }
    }, @set.recognize_path("GET", "/people/3/edit"))

    assert_equal({
      :controller => "dashboard",
      :action => "show",
      :id => "1"
    }, @set.recognize_path("GET", "/dashboard/show/1"))

    assert_equal({
      :controller => "people",
      :action => "show",
      :id => "1"
    }, @set.recognize_path("GET", "/people/show/1"))

    assert_equal({
      :controller => "sessions",
      :action => "new",
      :conditions => { :method => :get }
    }, @set.recognize_path("GET", "/login"))

    assert_equal({
      :controller => "sessions",
      :action => "new",
      :conditions => { :method => :get }
    }, @set.recognize_path("GET", "/login/"))

    assert_equal({
      :controller => "messages",
      :action => "edit",
      :id => "1"
    }, @set.recognize_path("GET", "/messages/edit/1"))

    assert_equal({
      :controller => "posts",
      :action => "index",
      :format => "xml",
      :token => "123456"
    }, @set.recognize_path("GET", "/123456/posts.xml"))

    assert_raise(Routing::RoutingError) { @set.recognize_path("GET", "/messages/2") }
  end

  # def test_generate
  #   assert_equal "/controller/action/variable", @set.generate({
  #     :controller => "controller",
  #     :action => "action",
  #     :variable => "variable"
  #   })
  # end

  def test_add_route_with_frozen_set
    assert_raise(RuntimeError) do
      @set.add_route("login", :controller => "sessions")
    end
  end
end
