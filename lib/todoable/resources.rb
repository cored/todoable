require "dry-struct"

module Todoable
  module Resources
    module Types
      include Dry::Types.module
    end
  end
end

require_relative "./resources/token"
