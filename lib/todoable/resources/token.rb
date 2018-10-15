module Todoable
  module Resources
    class Token < Dry::Struct
      transform_keys(&:to_sym)

      def self.resource_url
        "/api/authenticate"
      end

      attribute :token, Types::String.default("")
      attribute :expires_at, Types::Date

      def valid?
        !token.empty?
      end

      def to_s
        token
      end
    end
  end
end
