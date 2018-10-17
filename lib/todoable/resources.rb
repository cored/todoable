require "dry-struct"

module Todoable
  module Resources
    module Types
      include Dry::Types.module
    end
  end
end

require_relative "./resources/token"
require_relative "./resources/item"
require_relative "./resources/list"
require_relative "./resources/lists"
