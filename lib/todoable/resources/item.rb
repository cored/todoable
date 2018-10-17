module Todoable
  module Resources
    class Item < Dry::Struct
      transform_keys(&:to_sym)

      def self.resource_url(list_id:)
        "/api/lists/#{list_id}/items"
      end

      def self.for(attrs)
        new(attrs["item"])
      end

      attribute :name, Types::String
      attribute :id, Types::String.meta(omittable: true)
      attribute :src, Types::String.meta(omittable: true)
      attribute :finished_at, Types::Date.meta(omittable: true)

      def with(attrs)
        self.new(to_h.merge(attrs))
      end

      def to_json
        { "item" => { "name" => name } }
      end
    end
  end
end
