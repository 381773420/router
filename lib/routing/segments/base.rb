module Routing
  module Segments
    class Base
      include Graphable

      attr_reader :children

      def initialize
        if self.class == Base
          raise ArgumentError, "Base is an abstract class"
        end

        @children = Collection.new
      end

      def =~(node)
        raise NotImplemented, "#{self.class} should implement match"
      end

      def inspect
        to_s.inspect
      end

      def freeze
        @children.freeze
        super
      end

      def build(segments, leaf)
        if frozen?
          raise RuntimeError, "Can not modify frozen Segment"
        end

        unless leaf.is_a?(Segments::Leaf)
          leaf = Segments::Leaf.new(leaf)
        end

        parent = self
        segments.each do |segment|
          parent = parent.push(segment)
        end
        parent.close(leaf)
      end

      # Include native walker
      include RouterExt

      # def walk(segments, position)
      #   unless frozen?
      #     raise RuntimeError, "Can not traverse unfrozen Segment"
      #   end
      # 
      #   segment = segments[position]
      #   @children.each do |child|
      #     if child =~ segment
      #       if route = child.walk(segments, position + 1)
      #         return route
      #       end
      #     end
      #   end
      # 
      #   nil
      # end

      # def walk(segments, position)
      #   optimized_walk(segments, position)
      # end
      # 
      # def unwrap_walker_loop!
      #   source = ""
      #   source += %{
      #     def optimized_walk(segments, position)
      #       segment = segments[position]}
      #   @children.each_with_index do |child, index|
      #     source += %{
      #         child = @children[#{index}]
      #         if child =~ segment
      #           if route = child.walk(segments, position + 1)
      #             return route
      #           end
      #         end}
      #     end
      #   source += %{
      #       nil
      #     end
      #   }
      #   instance_eval(source)
      # end

      protected
        def push(node)
          @children.detect_or_push(node)
        end

        def close(leaf)
          slash = Separator.new("/")
          push(leaf)
          push(slash).push(leaf)
        end
    end
  end
end
