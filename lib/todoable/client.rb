require "faraday"
require "faraday_middleware"

module Todoable
  class Client
    def initialize(username:, password:)
      @conn = build_connection
      @username = username
      @password = password
    end

    def all
      retrieve_token
      conn.get("/api/lists", {}, build_request_headers).body['lists'].map do |todo|
        {name: todo['name']}
      end
    end

    def create(name:)
      retrieve_token
      conn.post "/api/lists", build_create_list_request(name), build_request_headers
    end

    private

    attr_reader :conn, :token

    def build_create_list_request(name)
      { "list" => {"name" => name} }
    end

    def build_request_headers
      {"Authorization" => "Token token=\"#{token}\""}
    end

    def retrieve_token
      conn.basic_auth username, password
      @token = conn.post("/api/authenticate").body['token']
    end

    def build_connection
      Faraday.new(url: "http://todoable.teachable.tech/") do |conn|
        conn.request :json
        conn.response :json
        conn.adapter Faraday.default_adapter
      end
    end

    attr_reader :conn, :username, :password, :http_client
  end
end
