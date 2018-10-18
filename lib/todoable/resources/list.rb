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
        self.new(
          to_h.merge(
            id: attrs["id"],
            src: attrs["src"],
            name: attrs["name"]
          ).merge(items: Array(attrs["items"]).map do |item_attrs|
              Item.for({"item" => item_attrs.merge("list_id" => id)})
            end)
        )
      end

      def to_json
        { "list" => {"name" => name} }
      end
    end
  end
end
