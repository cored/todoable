require "todoable/version"
require "dotenv/load"
require_relative "./todoable/adapters"
require_relative "./todoable/resources"
require_relative "./todoable/client"

module Todoable
  BASE_API_URL = ENV.fetch("BASE_API_URL", "http://todoable.teachable.tech/")

  def self.authenticate!(username: ENV["TODOABLE_USERNAME"], password: ENV["TODOABLE_PASSWORD"])
    Client.new(
      adapter: Adapters::HTTP.with_credentials(username: username,
                                               password: password)
    )
  end
end
