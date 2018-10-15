module Todoable
  class Client
    def initialize(http_adapter:)
      @http_adapter = http_adapter
    end

    def lists
      parsed_response = http_adapter.get(url: "/api/lists")
      parsed_response["lists"].map do |list|
        {name: list["name"]}
      end
    end

    def create_list!(name:)
      http_adapter.post(url: "/api/lists",
                        params: build_create_list_request(name))
    end

    private

    attr_reader :http_adapter

    def build_create_list_request(name)
      { "list" => {"name" => name} }
    end
  end
end
