require "json"

module Todoable
  module Resources
    class List < Dry::Struct
      transform_keys(&:to_sym)

      attribute :name, Types::String
      attribute :id, Types::String.meta(omittable: true)
      attribute :src, Types::String.meta(omittable: true)

      def with(attrs)
        self.new(to_h.merge(attrs))
      end

      def to_json
        { "list" => {"name" => name} }
      end
    end

    class Lists < Dry::Struct
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

      NoList = Struct.new(:name, :id, :src)
      def find_by(attrs)
        lists.find do |list|
          list.to_h.has_key?(*attrs.keys) &&
            list.to_h.has_value?(*attrs.values)
        end || NoList.new
      end

      def to_a
        lists
      end
    end
  end
end
