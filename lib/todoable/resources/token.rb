module Todoable
  module Resources
    class Token < Dry::Struct
      transform_keys(&:to_sym)

      def self.resource_url
        "/api/authenticate"
      end

      attribute :token, Types::String.default("")
      attribute :expires_at, Types::Strict::DateTime

      def valid?
        !token.empty? && !has_twenty_minutes_passed?
      end

      def to_s
        token
      end

      private

      def has_twenty_minutes_passed?
        ((expires_at.to_time - Time.now).to_i.abs / 60) == 20
      end
    end
  end
end
