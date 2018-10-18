module Todoable
  class Client
    def initialize(http_adapter:)
      @http_adapter = http_adapter
    end

    def lists
      Resources::Lists.for(http_adapter.get(url: Resources::Lists.url))
    end

    def list(id:)
      list = Resources::List.new(id: id)
      list.with(http_adapter.get(url: list.url))
    end

    def create_list!(name:)
      list = Resources::List.new(name: name)
      list.with(
        http_adapter.post(url: list.url, params: list.to_json)
      )
    end

    def update_list!(id:, name:)
      list = Resources::List.new(id: id, name: name)
      list.with(http_adapter.patch(url: list.url, params: list.to_json))
    end

    def delete_list!(id:)
      list = Resources::List.new(id: id)
      http_adapter.delete(url: list.url)
      self
    end

    def create_item!(list_id:, name:)
      item = Resources::Item.new(name: name, list_id: list_id)
      item.with(
        http_adapter.post(
          url: item.url,
          params: item.to_json
        )
      )
    end

    private

    attr_reader :http_adapter
  end
end
