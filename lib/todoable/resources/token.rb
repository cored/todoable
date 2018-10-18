module Todoable
  module Resources
    class Token < Dry::Struct
      transform_keys(&:to_sym)

      attribute :token, Types::String.default("")
      attribute :expires_at, Types::Strict::DateTime.default(DateTime.new)

      def url
        "/api/authenticate"
      end

      def with(attrs)
        new(
          attrs.merge("expires_at" => DateTime.parse(attrs["expires_at"]))
        )
      end

      def valid?
        !token.empty? && !has_twenty_minutes_passed?
      end

      def to_s
        token
      end

      private

      def has_twenty_minutes_passed?
        ((expires_at.to_time.to_i - Time.now.to_i).abs / 60) == 20
      end
    end
  end
end
