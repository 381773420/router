module Routing
  module Segments
    class Dynamic < Base
      def self.create_for_requirements(segment, requirements = nil)
        if requirements
          key = segment.sub(/^:/, '').to_sym
          requirements = requirements[key]
        end
        new(segment, requirements)
      end

      attr_reader :key, :requirements

      def initialize(key, requirements = nil)
        @key = key.sub(/^:/, "").to_sym
        @requirements = requirements.freeze

        super()
      end

      def to_s
        ":#{@key}"
      end

      def to_sym
        @key
      end

      def inspect
        if @requirements
          %{":#{@key} (#{@requirements.inspect})"}
        else
          %{":#{@key}"}
        end
      end

      def eql?(segment)
        segment.is_a?(self.class) &&
          self.key.eql?(segment.key) &&
          self.requirements.eql?(segment.requirements)
      end

      def match!(segment)
        result = if @requirements
          @requirements =~ segment
        else
          true
        end

        result ? true : false
      end
    end
  end
end
