require "spec_helper"

RSpec.describe Todoable, :vcr do
  subject(:todoable) do
    described_class.authenticate!(username: ENV["API_USERNAME"], password: ENV["API_PASSWORD"])
  end

  describe ".lists" do
    context "when several lists exists" do
      before { create_todos }

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

    context "when no lists exist" do
      it "return an empty collection of lists " do
      end
    end
  end
end

def create_todos
  1.upto(5) { |number| todoable.create(name: "Todo #{number}") }
end
