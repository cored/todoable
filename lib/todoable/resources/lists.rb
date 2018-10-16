module Todoable
  module Resources
    class List < Dry::Struct
      transform_keys(&:to_sym)

      attribute :name, Types::String
      attribute :id, Types::String
      attribute :src, Types::String
    end

    class Lists < Dry::Struct
      def self.resource_url
        "/api/lists"
      end

      def self.for(lists_attrs)
        new(
          lists: lists_attrs["lists"].map do |list|
            List.new(list)
          end
        )
      end

      attribute :lists, Types::Array.of(List)

      def to_a
        lists
      end
    end
  end
end
