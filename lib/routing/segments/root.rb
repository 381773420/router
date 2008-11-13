module Routing
  module Segments
    class Root < Base
      def initialize
        super()
      end

      def eql?(segment)
        false
      end

      def to_s
        ""
      end

      def =~(node)
        raise ArgumentError, "Root segment can not be matched"
      end

      def add_route(path, options = {})
        Leaf.new(path, options).attach(self)
      end

      def recognize_path(method, path)
        segments = Leaf.split_into_plain_segments(path)
        segments.freeze # remove this for performance reasons
        result = walk(method, segments) and return result

        raise RoutingError, "No route matches #{path.inspect} with #{method.inspect}"
      end

      def walk(method, segments)
        @children.each do |child|
          if child =~ method
            if route = child.walk(segments)
              return route
            end
          end
        end

        nil
      end
    end
  end
end
