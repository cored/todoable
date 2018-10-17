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
      list.with(
        http_adapter.post(url: Resources::Lists.resource_url,
                          params: list.to_json)
      )
    end

    private

    attr_reader :http_adapter
  end
end
