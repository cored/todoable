module Todoable
  module Resources
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
  end
end
