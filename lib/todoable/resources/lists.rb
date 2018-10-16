module Todoable
  module Resources
    class List < Dry::Struct
      transform_keys(&:to_sym)

      attribute :name, Types::String
      attribute :id, Types::String.meta(omittable: true)
      attribute :src, Types::String.meta(omittable: true)
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

      def find_by(attrs)
        lists.find do |list|
          list.to_h.has_key?(*attrs.keys) &&
            list.to_h.has_value?(*attrs.values)
        end
      end

      def to_a
        lists
      end
    end
  end
end
