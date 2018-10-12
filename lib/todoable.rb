require "todoable/version"
require "dotenv/load"
require_relative "./todoable/client"

module Todoable
  def self.authenticate!(username:, password:)
    Client.new(username: username, password: password)
  end
end
