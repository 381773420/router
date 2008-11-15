module Routing
  module Segments
    module Graphable
      def to_graph
        graph_descendants = descendants

        nodes = graph_label + "\n"
        nodes += graph_descendants.map { |node| node.send :graph_label }.join("\n")

        relationships = graph_relationships
        relationships += graph_descendants.map { |parent| parent.graph_relationships }.join("\n")

        "digraph routes {\n#{nodes}\n#{relationships}\n}"
      end

      protected
        def graph_node_id
          "node#{object_id}"
        end

        def graph_label
          if is_a?(Leaf)
            "#{graph_node_id}[shape=doublecircle,height=.5,label=#{inspect}];"
          else
            "#{graph_node_id}[shape=circle,height=.5,label=#{inspect.inspect}];"
          end
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
    end
  end
end
