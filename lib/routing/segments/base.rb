module Routing
  module Segments
    class Base
      attr_reader :children

      def initialize
        if self.class == Base
          raise ArgumentError, "Base is an abstract class"
        end

        @children = Array.new
      end

      def match!(node)
        raise NotImplemented, "#{self.class} should implement match"
      end

      def inspect
        to_s.inspect
      end

      def freeze
        @children.freeze
        @children.each { |child| child.freeze }
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

      def walk(segments, position = 0)
        unless frozen?
          raise RuntimeError, "Can not traverse unfrozen Segment"
        end

        segment = segments[position]
        @children.each do |child|
          if child.match!(segment)
            if route = child.walk(segments, position + 1)
              return route
            end
          end
        end

        nil
      end

      def to_graph
        nodes = graph_label + "\n"
        nodes += descendants.map { |node| node.send :graph_label }.join("\n")

        relationships = graph_relationships
        relationships += descendants.map { |parent| parent.graph_relationships }.join("\n")

        "digraph routes {\n#{nodes}\n#{relationships}\n}"
      end

      protected
        def graph_node_id
          "node#{object_id}"
        end

        def graph_label
          "#{graph_node_id}[shape=circle,height=.5,label=#{inspect.inspect}];"
        end

        def graph_relationships
          children.map { |child| "#{graph_node_id} -> #{child.graph_node_id};" }.join("\n")
        end

        def descendants
          descendants = []
          @children.each do |child|
            descendants << child
            child.descendants.each do |descendant|
              descendants << descendant
            end
          end
          descendants
        end

        def push(node)
          raise ArgumentError unless node.is_a?(Base)

          if existing_node = find_existing_node(node)
            return existing_node
          else
            @children << node
            return node
          end
        end

        def close(leaf)
          slash = Separator.new("/")
          push(leaf)
          push(slash).push(leaf)
        end

      private
        def find_existing_node(node)
          existing_node = nil
          @children.reverse.each do |child|
            existing_node = child if node.eql?(child)
            break if child.is_a?(Dynamic)
          end
          existing_node
        end
    end
  end
end
