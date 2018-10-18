require "faraday"
require "faraday_middleware"

module Todoable
  module Adapters
    class HTTP
      class InvalidCredentialsError < StandardError; end
      class UnprocessableEntityError < StandardError; end
      class NotFoundError < StandardError; end
      class UnauthorizedError < StandardError; end

      HTTP_OK_CODE = 200
      HTTP_CREATED_CODE = 201
      HTTP_NO_CONTENT_CODE = 204
      HTTP_UNAUTHORIZED_CODE = 401
      HTTP_UNPROCCESSABLE_ENTITY_CODE = 422

      ERRORS = {
        HTTP_UNAUTHORIZED_CODE => InvalidCredentialsError.new("Please verify your username or password"),
        HTTP_UNPROCCESSABLE_ENTITY_CODE => UnprocessableEntityError.new("Unprocessable entity"),
      }

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
        @token = Resources::Token.new
      end

      def post(url:, params:)
        authorize!
        request(
          http_method: :post,
          url: url,
          params: params,
        )
      end

      def get(url:)
        authorize!
        request(
          http_method: :get,
          url: url,
          params: {},
        )
      end

      def delete(url:)
        authorize!
        request(
          http_method: :delete,
          url: url,
          params: {},
        )
      end

      def patch(url:, params:)
        authorize!
        request(
          http_method: :patch,
          url: url,
          params: params,
        )
      end

      def put(url:, params:)
        authorize!
        request(
          http_method: :put,
          url: url,
          params: params,
        )
      end

      private

      attr_reader :connection, :token, :response

      def authorize!
        unless token.valid?
          @token = token.with(
            request(
              http_method: :post,
              url: token.url,
              params: {}
            )
          )
          connection.authorization(:Token, token: token)
        end
      end

      def request(http_method:, url:, params: {})
        @response = connection.public_send(http_method, url, params)
        return response.body if successful_response?

        raise ERRORS.fetch(response.status)
      rescue Faraday::ParsingError
        if response_created_ok?
          if params.empty?
            return response.body
          else
            return response.body.merge(*params.values)
          end
        end
        raise UnprocessableEntityError.new("Unprocessable entity: #{response.body}")
      end

      def successful_response?
          response_ok? || response_created_ok? || response_no_content?
      end

      def response_ok?
        response.status == HTTP_OK_CODE
      end

      def response_created_ok?
        response.status == HTTP_CREATED_CODE
      end

      def response_no_content?
        response.status == HTTP_NO_CONTENT_CODE
      end
    end
  end
end
