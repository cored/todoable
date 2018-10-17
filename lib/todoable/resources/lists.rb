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
        new(to_h.merge(attrs))
      end

      def to_json
        { "item" => { "name" => name } }
      end
    end

    class List < Dry::Struct
      transform_keys(&:to_sym)

      attribute :name, Types::String.default("")
      attribute :id, Types::String.meta(omittable: true)
      attribute :src, Types::String.meta(omittable: true)
      attribute :items, Types::Array.of(Item).default([])

      def with(attrs)
        self.new(to_h.merge(attrs))
      end

      def to_json
        { "list" => {"name" => name} }
      end
    end

    class Lists < Dry::Struct
      include Enumerable

      def self.resource_url
        "/api/lists"
      end

      def self.for(lists_attrs)
        new(
          lists: Array(lists_attrs["lists"]).map do |list|
            List.new(list)
          end
        )
      end

      attribute :lists, Types::Array.of(List).meta(omittable: true)

      def each(&block)
        lists.each(&block)
      end

      NoList = Struct.new(:name, :id, :src)
      def find_by(attrs)
        lists.find do |list|
          list.to_h.has_key?(*attrs.keys) &&
            list.to_h.has_value?(*attrs.values)
        end || NoList.new
      end
    end
  end
end
