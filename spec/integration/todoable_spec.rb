require "spec_helper"

RSpec.describe Todoable, :vcr do
  subject(:todoable) do
    described_class.authenticate!(username: ENV["API_USERNAME"],
                                  password: ENV["API_PASSWORD"])
  end

  describe ".lists" do
    before do
      delete_lists
      create_lists
    end

    it "return a collection of lists" do
      expect(
        todoable.lists.to_a.map(&:to_h)
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
    before { delete_list("Testing List") }

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
end

def create_lists
  1.upto(5) { |number| create_list("List #{number}") }
end

def create_list(name)
  todoable.create_list!(name: name)
end

def delete_lists
  1.upto(5) { |number| delete_list("List #{number}") }
end

def delete_list(name)
  list = todoable.lists.find_by(name: name)
  todoable.delete_list!(id: list.id)
end
