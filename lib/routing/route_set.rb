module Routing
  class RoutingError < StandardError #:nodoc:
    attr_reader :failures
    def initialize(message, failures=[])
      super(message)
      @failures = failures
    end
  end

  class MethodNotAllowed < StandardError #:nodoc:
    attr_reader :allowed_methods

    def initialize(*allowed_methods)
      super("Only #{allowed_methods.to_sentence} requests are allowed.")
    end
  end

  class NotImplemented < StandardError #:nodoc:
  end

  class RouteSet
    class Mapper
      def initialize(set)
        @set = set
      end

      def connect(path, options = {})
        @set.add_route(path, options)
      end

      def named_route(name, path, options = {})
        @set.add_named_route(name, path, options)
      end

      def resources(resource, options = {})
        send("#{resource}", "/#{resource}", :controller => "#{resource}", :action => "index", :conditions => { :method => :get })
        send("formatted_#{resource}", "/#{resource}.:format", :controller => "#{resource}", :action => "index", :conditions => { :method => :get })

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

      def method_missing(route_name, *args, &proc)
        super unless args.length >= 1 && proc.nil?
        @set.add_named_route(route_name, *args)
      end
    end

    attr_reader :named_routes

    def initialize
      @root = Segments::Root.new
      @named_routes = NamedRouteCollection.new
    end

    def draw
      yield Mapper.new(self)
      freeze
      self
    end

    def add_route(path, options = {})
      @root.add_route(path, options)
    end

    def add_named_route(name, path, options = {})
      named_routes[name.to_sym] = add_route(path, options)
    end

    def recognize_path(method, path)
      @root.recognize_path(method, path)
    end

    def generate(options)
      @root.generate(options)
    end

    def lookup_named_route(name)
      named_routes[name.to_sym]
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
