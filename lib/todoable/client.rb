require "faraday"
require "faraday_middleware"

module Todoable
  BASE_API_URL = ENV.fetch("BASE_API_URL", "http://todoable.teachable.tech/")
  # HTTP Codes
  HTTP_OK_CODE = 200
  HTTP_UNPROCESSABLE_ENTITY_CODE = 422

  # Errors
  class UnprocessableEntityError < StandardError; end


  class Client
    def initialize(username:, password:, http_client: Faraday)
      @http_adapter = build_connection_and_authenticate_with(username, password, http_client)
    end

    def lists
      parsed_response = make_request(
        http_method: :get,
        url: "/api/lists",
        params: {},
      )
      parsed_response["lists"].map do |list|
        {name: list["name"]}
      end
    end

    def create_list!(name:)
      make_request(
        http_method: :post,
        url: "/api/lists",
        params: build_create_list_request(name)
      )
    end

    private

    attr_reader :http_adapter, :response

    def make_request(http_method:, url:, params:)
      @response = http_adapter.public_send(http_method, url, params, build_request_headers)
      return response.body if successful_response?
      raise error_class.new("Code: #{response.status}, response: #{response.body}")
    end

    def successful_response?
      response.status == HTTP_OK_CODE
    end

    def error_class
      case response.status
      when HTTP_UNPROCESSABLE_ENTITY_CODE
        UnprocessableEntityError
      end
    end

    def build_create_list_request(name)
      { "list" => {"name" => name} }
    end

    def build_request_headers
      {"Authorization" => "Token token=\"#{token}\""}
    end

    def token
      @_token = http_adapter.post("/api/authenticate").body['token']
    end

    def build_connection_and_authenticate_with(username, password, http_client)
      http_adapter = http_client.new(url: BASE_API_URL) do |conn|
        conn.request :json
        conn.response :json
        conn.adapter http_client.default_adapter
      end
      http_adapter.basic_auth username, password
      http_adapter
    end
  end
end
