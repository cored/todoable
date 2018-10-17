require "spec_helper"

RSpec.describe Todoable, :vcr do
  subject(:todoable) do
    described_class.authenticate!(username: ENV["TODOABLE_USERNAME"],
                                  password: ENV["TODOABLE_PASSWORD"])
  end

  include IntegrationSpecHelpers

  describe "#create_item!" do
    before { delete_list("Another list for testing") }

    let(:list_for_item) do
      todoable.create_list!(name: "Another list for testing")
    end

    it "creates a new todo item for a list" do
      expect(
        todoable.create_item!(list_id: list_for_item.id, name: "New item").to_h
      ).to match(
        a_hash_including({name: "New item", finished_at: nil})
      )
    end
  end

  describe "#mark_item_finished!" do
    let(:list_for_item) do
      todoable.create_list!(name: "Updating an item")
    end
    let(:item_to_mark_finished) do
      todoable.create_item!(list_id: list_for_item.id, name: "Buy Milk!")
    end

    it "marks an item on a list as finished" do
      expect(
        todoable.mark_item_finished!(
          list_id: list_for_item.id,
          id: item_to_mark_finished.id)
        .to_h[:finished_at]
      ).to_not be_nil
    end
  end
end
