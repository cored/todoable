require "spec_helper"

RSpec.describe Todoable, :vcr do
  subject(:todoable) do
    described_class.authenticate!(username: ENV["API_USERNAME"], password: ENV["API_PASSWORD"])
  end

  describe ".lists" do
    context "when several lists exists" do
      before { create_lists }

      it "return a collection of lists" do
        expect(
          todoable.lists
        ).to match_array([
          {name: "Todo 1"},
          {name: "Todo 2"},
          {name: "Todo 3"},
          {name: "Todo 4"},
          {name: "Todo 5"}
        ])
      end
    end
  end

  describe ".create_list!" do
    context "when passing a blank name for a new list" do
      it "throws an unproccesable entity error" do
        # expect {
        #   todoable.create_list!(name: "")
        # }.to raise_error(described_class::UnprocessableEntityError)
      end
    end
  end
end

def create_lists
  1.upto(5) { |number| create_list("Todo #{number}") }
end

def create_list(name)
  todoable.create_list!(name: name)
end
