require "spec_helper"

RSpec.describe Todoable::Client do
  subject(:todoable_client) do
    described_class.new(http_adapter: http_adapter)
  end
  let(:http_adapter) do
    instance_double "Adapters::HTTP", get: get_response, post: post_response
  end
  let(:get_response) { {} }
  let(:post_response) { {} }

  describe "#lists" do
    context "when there are no lists created" do
      let(:get_response) { { "lists" => [] } }

      it "returns an empty collection" do
        expect(todoable_client.lists).to eql(Todoable::Resources::Lists.new(lists: []))
      end
    end

    context "when some lists exists" do
      let(:get_response) do
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

  describe "#create_list!" do
    let(:post_response) { {} }
    let(:get_response) do
      {
        "lists" => [
          {"name" => "My List", "src" => "/path/list", "id" => "uuid"},
        ]
      }
    end
    let(:expected_list) do
      Todoable::Resources::List.new(
        name: "My List",
        src: "/path/list",
        id: "uuid"
      )
    end

    it "creates a new list" do
      expect(
        todoable_client.create_list!(name: "My List")
      ).to eql expected_list
    end
  end
end
