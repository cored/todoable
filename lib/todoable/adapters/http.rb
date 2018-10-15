module Todoable
  module Adapters
    class HTTP
      def self.with_credentials(username:, password:, http_client: Faraday)
        conn = http_client.new(url: BASE_API_URL) do |faraday|
          faraday.request :json
          faraday.response :json
          faraday.adapter http_client.default_adapter
        end
        conn.basic_auth username, password
        new(connection: conn)
      end

      def initialize(connection:)
        @connection = connection
        @token = retrieve_token
      end

      def post(url:, params:)
        connection.post(url, params, headers)
      end

      def get(url:)
        connection.get(url, {}, headers).body
      end

      private

      attr_reader :connection, :token

      def headers
        {"Authorization" => "Token token=\"#{token}\""}
      end

      def retrieve_token
        response = connection.post("/api/authenticate")
        response.body["token"]
      end
    end
  end
end
