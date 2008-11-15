module Routing
  module Segments
    class Collection < Array
      def detect_or_push(node)
        raise ArgumentError unless node.is_a?(Base)

        if existing_node = find_existing_node(node)
          return existing_node
        else
          self << node
          return node
        end
      end

      def freeze
        each { |child| child.freeze }
        super
      end

      private
        def find_existing_node(node)
          existing_node = nil
          reverse.each do |child|
            existing_node = child if node.eql?(child)
            break if child.is_a?(Dynamic)
          end
          existing_node
        end
    end
  end
end
