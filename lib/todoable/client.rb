require "faraday"
require "faraday_middleware"

module Todoable
  BASE_API_URL = ENV.fetch("BASE_API_URL", "http://todoable.teachable.tech/")

  class Client
    def initialize(username:, password:, http_client: Faraday)
      @http_adapter = build_connection_and_authenticate_with(username, password, http_client)
    end

    def lists
      http_adapter.get("/api/lists", {}, build_request_headers).body['lists'].map do |list|
        {name: list['name']}
      end
    end

    def create_list!(name:)
      http_adapter.post "/api/lists", build_create_list_request(name), build_request_headers
    end

    private

    attr_reader :http_adapter

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
