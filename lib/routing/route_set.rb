module Routing
  class RouteSet
    class Mapper
      def initialize(set)
        @set = set
      end

      def connect(path, options = {})
        @set.add_route(path, options)
      end

      def resources(resource, options = {})
        connect "/#{resource}", :controller => "#{resource}", :action => "index", :conditions => { :method => :get }
        connect "/#{resource}.:format", :controller => "#{resource}", :action => "index", :conditions => { :method => :get }
        connect "/#{resource}", :controller => "#{resource}", :action => "create", :conditions => { :method => :post }
        connect "/#{resource}.:format", :controller => "#{resource}", :action => "create", :conditions => { :method => :post }
        connect "/#{resource}/new", :controller => "#{resource}", :action => "new", :conditions => { :method => :get }
        connect "/#{resource}/new.:format", :controller => "#{resource}", :action => "new", :conditions => { :method => :get }
        connect "/#{resource}/:id/edit", :controller => "#{resource}", :action => "edit", :conditions => { :method => :get }
        connect "/#{resource}/:id/edit.format", :controller => "#{resource}", :action => "edit", :conditions => { :method => :get }
        connect "/#{resource}/:id", :controller => "#{resource}", :action => "show", :conditions => { :method => :get }
        connect "/#{resource}/:id.:format", :controller => "#{resource}", :action => "show", :conditions => { :method => :get }
        connect "/#{resource}/:id", :controller => "#{resource}", :action => "update", :conditions => { :method => :put }
        connect "/#{resource}/:id.:format", :controller => "#{resource}", :action => "update", :conditions => { :method => :put }
        connect "/#{resource}/:id", :controller => "#{resource}", :action => "destroy", :conditions => { :method => :delete }
        connect "/#{resource}/:id.:format", :controller => "#{resource}", :action => "destroy", :conditions => { :method => :delete }
      end
    end

    def initialize
      @root = Segments::Root.new
    end

    def draw
      yield Mapper.new(self)
      freeze
      self
    end

    def add_route(path, options = {})
      @root.add_route(path, options)
    end

    def recognize_path(method, path)
      @root.recognize_path(method, path)
    end

    def generate(options)
      @root.generate(options)
    end

    def freeze
      @root.freeze
    end

    def to_graph
      @root.to_graph
    end
  end

  Routes = RouteSet.new
end
