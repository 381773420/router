module Routing
  module Segments
    class Separator < Static
      SEPARATORS = %w( / . ? )
      SEPARATORS_REGEXP = /(\/|\.|\?)/

      def initialize(value = nil)
        unless SEPARATORS.include?(value)
          raise ArgumentError, "Value must be in #{SEPARATORS.inspect}"
        else
          super
        end
      end
    end
  end
end
