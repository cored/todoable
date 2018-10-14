require "spec_helper"

RSpec.describe Todoable, :vcr do
  subject(:todoable) do
    described_class.authenticate!(username: ENV["API_USERNAME"], password: ENV["API_PASSWORD"])
  end

  describe ".all" do
    context "when todo's exist" do
      before { create_todos }

      it "return a list of todos" do
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

    context "when todo's does not exist" do
    end
  end
end

def create_todos
  1.upto(5) { |number| todoable.create(name: "Todo #{number}") }
end
