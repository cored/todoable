module Todoable
  class Client
    def initialize(http_adapter:)
      @http_adapter = http_adapter
    end

    def lists
      Resources::Lists.for(
        http_adapter.get(url: Resources::Lists.resource_url)
      )
    end

    def create_list!(name:)
      list = Resources::List.new(name: name)
      http_adapter.post(url: Resources::Lists.resource_url,
                        params: list.to_json)
      find_list_with(name)
    end

    private

    attr_reader :http_adapter

    def build_create_list_request(name)
      { "list" => {"name" => name} }
    end

    def find_list_with(name)
      lists.find_by(name: name)
    end
  end
end
