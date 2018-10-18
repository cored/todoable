module Todoable
  module Resources
    class List < Dry::Struct
      transform_keys(&:to_sym)

      attribute :name, Types::Name
      attribute :id, Types::Id
      attribute :src, Types::Src
      attribute :items, Types::Array.of(Item).default([])

      def url
        "/api/lists/#{id}"
      end

      def with(attrs)
        self.new(to_h.merge(attrs))
      end

      def to_json
        { "list" => {"name" => name} }
      end
    end
  end
end
