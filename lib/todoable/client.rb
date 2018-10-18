module Todoable
  class Client
    def initialize(adapter:)
      @adapter = adapter
    end

    def lists
      Resources::Lists.for(adapter.get(url: Resources::Lists.url))
    end

    def list(id:)
      list = Resources::List.new(id: id)
      list.with(adapter.get(url: list.url))
    end

    def create_list!(name:)
      list = Resources::List.new(name: name)
      list.with(adapter.post(url: list.url, params: list.to_json))
    end

    def update_list!(id:, name:)
      list = Resources::List.new(id: id, name: name)
      list.with(adapter.patch(url: list.url, params: list.to_json))
    end

    def delete_list!(id:)
      list = Resources::List.new(id: id)
      adapter.delete(url: list.url)
      self
    end

    def create_item!(list_id:, name:)
      item = Resources::Item.new(name: name, list_id: list_id)
      item.with(
        adapter.post(
          url: item.url,
          params: item.to_json
        )
      )
    end

    def mark_item_finished!(list_id:, id:)
      item = Resources::Item.new(list_id: list_id, id: id)
      item.with(
        adapter.put(
          url: item.finish_url,
          params: {}
        ).merge(finished_at: Date.today)
      )
    end

    def delete_item!(list_id:, id:)
      item = Resources::Item.new(list_id: list_id, id: id)
      adapter.delete(url: item.url)
      self
    end

    private

    attr_reader :adapter
  end
end
