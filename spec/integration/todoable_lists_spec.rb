require "spec_helper"

RSpec.describe Todoable, :vcr do
  subject(:todoable) do
    described_class.authenticate!(username: ENV["TODOABLE_USERNAME"],
                                  password: ENV["TODOABLE_PASSWORD"])
  end

  include IntegrationSpecHelpers

  describe ".lists" do
    before do
      delete_lists
      create_lists
    end

    it "return a collection of lists" do
      expect(
        todoable.lists.map(&:to_h)
      ).to include(
        a_hash_including({name: "List 1"}),
        a_hash_including({name: "List 2"}),
        a_hash_including({name: "List 3"}),
        a_hash_including({name: "List 4"}),
        a_hash_including({name: "List 5"}),
      )
    end
  end

  describe ".create_list!" do
    before {  delete_list("Testing List") }

    it "creates a new list" do
      expect(
        todoable
        .create_list!(name: "Testing List").to_h
      ).to match(
        a_hash_including({name: "Testing List"}),
      )
    end
  end

  describe ".list" do
    it "returns a list" do
      delete_list("List for retrieval")
      list = create_list("List for retrieval")

      expect(
        todoable.list(id: list.to_h[:id])
      ).to match(
        a_hash_including({name: "List for retrieval"}),
      )
    end
  end

  describe ".update_list!" do
    before { delete_list("list for todoable") }

    it "updates a list name" do
      list = create_list("list for todoable")

      expect(
        todoable.update_list!(id: list.id, name: "Updated name")
      ).to match(
        a_hash_including({name: "Updated name"})
      )
    end
  end
end

