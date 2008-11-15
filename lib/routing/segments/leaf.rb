module Routing
  module Segments
    class Leaf < Base
      # This must be very fast
      def self.split_into_plain_segments(path)
        segments = path.split(Segments::Separator::SEPARATORS_REGEXP)
        segments.shift
        segments
      end

      attr_reader :path, :options

      def initialize(path, options = {})
        path = "/#{path}" unless path =~ /^\//

        @path = path
        @options = options

        unless significant_keys.include?(:action)
          @options[:action] = "index"
        end

        unless significant_keys.include?(:controller)
          raise ArgumentError, "Illegal route: the :controller must be specified!"
        end

        super()

        @params_mapping = generate_params_mapping
      end

      def to_s
        if @options[:controller] && @options[:action]
          "#{@options[:controller].capitalize}Controller##{@options[:action]}"
        else
          @path
        end
      end

      def eql?(segment)
        segment.is_a?(self.class) &&
          self.path.eql?(segment.path) &&
          self.options == segment.options
      end

      def significant_keys
        option_keys = (@options.keys - [:conditions])
        param_keys = segments.find_all { |s| s.is_a?(Dynamic) }.map { |s| s.to_sym }
        option_keys + param_keys
      end

      def method
        (@options[:conditions] && @options[:conditions][:method]) || :any
      end

      def attach(root)
        Segments::Method.create(method).map do |segment|
          root.build(segments.dup.unshift(segment), self)
        end
        self
      end

      def =~(segment)
        segment.nil?
      end

      def walk(segments, position)
        params = @options.dup
        @params_mapping.each do |key, value|
          params[key] = segments[value]
        end
        params
      end

      private
        def segments
          self.class.split_into_plain_segments(path.dup).map do |segment|
            segment_for(segment)
          end
        end

        def segment_for(string)
          case string
            when /(\/|\.|\?)/
              Segments::Separator.new(string)
            when /^:/
              Segments::Dynamic.create_for_requirements(string, @options[:requirements])
            else
              Segments::Static.new(string)
          end
        end

        def generate_params_mapping
          mapping = {}
          segments.each_with_index do |segment, index|
            if segment.is_a?(Dynamic)
                mapping[segment.to_sym] = index
            end
          end
          mapping.freeze
        end
    end
  end
end
