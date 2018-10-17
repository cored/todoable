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

    def list(id:)
      Resources::List.new(
        http_adapter.get(url: "#{Resources::Lists.resource_url}/#{id}")
      )
    end

    def create_list!(name:)
      list = Resources::List.new(name: name)
      list.with(
        http_adapter.post(url: Resources::Lists.resource_url,
                          params: list.to_json)
      )
    end

    def update_list!(id:, name:)
      list = Resources::List.new(id: id, name: name)
      list.with(
        http_adapter.patch(
          url: "#{Resources::Lists.resource_url}/#{id}",
          params: list.to_json,
        )
      )
    end

    def delete_list!(id:)
      http_adapter.delete(url: "#{Resources::Lists.resource_url}/#{id}")
      self
    end

    def create_item!(list_id:, name:)
      item = Resources::Item.new(name: name)
      item.with(
        http_adapter.post(
          url: Resources::Item.resource_url(list_id: list_id),
          params: item.to_json
        )
      )
    end

    private

    attr_reader :http_adapter
  end
end
