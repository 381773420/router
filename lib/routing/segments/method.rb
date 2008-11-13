module Routing
  module Segments
    class Method < Base
      HTTP_METHODS = [:get, :post, :put, :delete]

      def self.create(method)
        methods = method == :any ? HTTP_METHODS : [method]
        methods.map { |method| new(method) }
      end

      def initialize(method)
        @string = method.to_s.upcase.freeze
        @symbol = method.to_s.downcase.to_sym

        if @symbol == :head
          raise ArgumentError, "HTTP method HEAD is invalid in route conditions. Rails processes HEAD requests the same as GETs, returning just the response headers"
        end

        unless HTTP_METHODS.include?(@symbol)
          raise ArgumentError, "Invalid HTTP method specified in route conditions: #{method.inspect}"
        end

        super()
      end

      def eql?(segment)
        segment.is_a?(self.class) &&
          self.to_sym.eql?(segment.to_sym)
      end

      def to_s
        @string
      end

      def to_sym
        @symbol
      end

      def match!(node)
        @string == node
      end
    end
  end
end
