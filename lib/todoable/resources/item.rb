module Todoable
  module Resources
    class Item < Dry::Struct
      transform_keys(&:to_sym)

      def self.for(attrs)
        new(attrs["item"])
      end

      attribute :name, Types::Name
      attribute :id, Types::Id
      attribute :src, Types::Src
      attribute :list_id, Types::String.meta(omittable: true)
      attribute :finished_at, Types::Date.meta(omittable: true)

      def finish_url
        "#{url}/#{id}/finish"
      end

      def delete_url
        "#{url}/#{id}"
      end

      def url
        "/api/lists/#{list_id}/items"
      end

      def with(attrs)
        self.new(to_h.merge(attrs))
      end

      def to_json
        { "item" => { "name" => name } }
      end
    end
  end
end
