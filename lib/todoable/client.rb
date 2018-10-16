module Todoable
  class Client
    def initialize(http_adapter:)
      @http_adapter = http_adapter
    end

    def lists
      Resources::Lists.for(
        http_adapter.get(url: Resources::Lists.resource_url)
      ).to_a
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
