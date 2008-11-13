module Routing
  module Segments
    class Static < Base
      attr_reader :value

      def initialize(value = nil)
        @value = value.freeze
        super()
      end

      def to_s
        @value.to_s
      end

      def eql?(segment)
        segment.is_a?(self.class) &&
          self.value.eql?(segment.value)
      end

      def match!(node)
        @value == node
      end
    end
  end
end
