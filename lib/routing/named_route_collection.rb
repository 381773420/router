module Routing
  class NamedRouteCollection
    include Enumerable

    attr_reader :routes

    def initialize
      @routes = {}
    end

    def []=(name, route)
      routes[:"#{name}_path"] = route
    end

    def [](name)
      routes[name.to_sym].path
    end
  end
end
