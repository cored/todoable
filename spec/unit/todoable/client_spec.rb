require "spec_helper"

RSpec.describe Todoable::Client do
  subject(:todoable_client) do
    described_class.new(http_adapter: http_adapter)
  end
  let(:http_adapter) do
    instance_double "Adapters::HTTP", get: response
  end

  describe "#lists" do
    context "when there are no lists created" do
      let(:response) { { "lists" => [] } }

      it "returns an empty collection" do
        expect(todoable_client.lists).to be_empty
      end
    end

    context "when some lists exists" do
      let(:response) do
        {
          "lists" => [
            {"name" => "List 1", "src" => "/path", "id" => "uuid"},
            {"name" => "List 2", "src" => "/path", "id" => "uuid"},
            {"name" => "List 3", "src" => "/path", "id" => "uuid"},
          ]
        }
      end

      it "returns a collection of lists" do
        expect(
          todoable_client.lists
        ).to contain_exactly(
          Todoable::Resources::List.new(name: "List 1", src: "/path", id: "uuid"),
          Todoable::Resources::List.new(name: "List 2", src: "/path", id: "uuid"),
          Todoable::Resources::List.new(name: "List 3", src: "/path", id: "uuid"),
        )
      end
    end
  end
end
