module Todoable
  module Adapters
    class HTTP
      class InvalidCredentialsError < StandardError; end
      class UnprocessableEntityError < StandardError; end

      HTTP_OK_CODE = 200
      HTTP_UNAUTHORIZED_CODE = 401
      HTTP_UNPROCCESSABLE_ENTITY_CODE = 422

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
        retrieve_token
      end

      def post(url:, params:)
        request(
          http_method: :post,
          url: url,
          params: params,
        )
      end

      def get(url:)
        request(
          http_method: :get,
          url: url,
          params: {},
        )
      end

      private

      attr_reader :connection, :token

      def retrieve_token
        @token = Resources::Token.for(
          request(http_method: :post, url: Resources::Token.resource_url)
        )
        build_authorization_headers if token.valid?
      end

      def build_authorization_headers
        connection.authorization(:Token, token: token)
      end

      def request(http_method:, url:, params: {})
        response = connection.public_send(http_method, url, params)
        return response.body if response.status == HTTP_OK_CODE

        case response.status
        when HTTP_UNAUTHORIZED_CODE
          raise InvalidCredentialsError.new("Please verify your username or password")
        when HTTP_UNPROCCESSABLE_ENTITY_CODE
          UnprocessableEntityError.new("Unprocessable entity: #{response.body}")
        end
      end
    end
  end
end
