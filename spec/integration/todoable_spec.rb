require "spec_helper"

RSpec.describe Todoable, :vcr do
  subject(:todoable) do
    described_class.authenticate!(username: ENV["API_USERNAME"],
                                  password: ENV["API_PASSWORD"])
  end

  describe ".lists" do
    before { create_lists }

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
    it "creates a new list" do
      expect(
        todoable
        .create_list!(name: "Testing List")
        .lists.to_a.map(&:to_h)
      ).to include(
        a_hash_including({name: "Testing List"}),
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
