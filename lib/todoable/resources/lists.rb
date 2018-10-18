module Todoable
  module Resources
    class Lists < Dry::Struct
      include Enumerable

      def self.url
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
