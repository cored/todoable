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
end
