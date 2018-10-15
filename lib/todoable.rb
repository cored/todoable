require "todoable/version"
require "dotenv/load"
require "faraday"
require "faraday_middleware"
require_relative "./todoable/adapters/http"
require_relative "./todoable/client"

module Todoable
  BASE_API_URL = ENV.fetch("BASE_API_URL", "http://todoable.teachable.tech/")

  def self.authenticate!(username:, password:)
    Client.new(
      http_adapter: Adapters::HTTP.with_credentials(username: username,
                                                    password: password)
    )
  end
end
