require "spec_helper"

RSpec.describe Todoable::Client do
  subject(:todoable_client) do
    described_class.new(http_adapter: http_adapter)
  end
  let(:http_adapter) do
    instance_double("Adapters::HTTP",
                    get: get_response,
                    post: post_response,
                    delete: delete_response,
                    patch: patch_response)
  end
  let(:get_response) { {} }
  let(:post_response) { {} }
  let(:delete_response) { {} }
  let(:patch_response) { {} }

  let(:get_response) { {} }
  let(:post_response) { {} }
  let(:delete_response) { {} }

  describe "#lists" do
    context "when there are no lists created" do
      let(:get_response) { { "lists" => [] } }

      it "returns an empty collection" do
        expect(
          todoable_client.lists
        ).to eql(Todoable::Resources::Lists.new(lists: []))
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
    let(:post_response) do
      {"name" => "My List", "src" => "/path/list", "id" => "uuid"}
    end
    let(:expected_list) do
      Todoable::Resources::List.new(
        {"name" => "My List", "src" => "/path/list", "id" => "uuid"}
      )
    end

    it "return the successful created list" do
      expect(
        todoable_client.create_list!(name: "My List")
      ).to eql expected_list
    end
  end

  describe "#update_list!" do
    let(:patch_response) do
      { "name" => "Updated", "src" => "/path/list", "id" => "uuid" }
    end
    let(:expected_list) do
      Todoable::Resources::List.new({
        "name" => "Updated",
        "src" => "/path/list",
        "id" => "uuid"
      })
    end

    it "return the updated list" do
      expect(
        todoable_client.update_list!(id: "uuid" , name: "Updated")
      ).to eql expected_list
    end
  end

  describe "#delete_list!" do
    let(:delete_response) { {} }

    it "returns client for successful creation" do
      expect(
        todoable_client.delete_list!(id: "list_id")
      ).to eql todoable_client
    end
  end

  describe "#list" do
    let(:get_response) do
      {"name" => "My List", "src" => "/path/list", "id" => "uuid"}
    end
    let(:expected_list) do
      Todoable::Resources::List.new(
        {"name" => "My List", "src" => "/path/list", "id" => "uuid"}
      )
    end

    it "returns a list base on an id" do
      expect(
        todoable_client.list(id: "uuid")
      ).to eql expected_list
    end
  end

  describe "#create_item!" do
    let(:post_response) do
      { "name" => "Feed the cat", "src" => "/path/list", "id" => "uuid" }
    end
    let(:expected_item) do
      Todoable::Resources::Item.new({
        "name" => "Feed the cat",
        "src" => "/path/list",
        "id" => "uuid"
      })
    end

    it "return the created item" do
      expect(
        todoable_client.create_item!(list_id: "list_id", name: "Feed the cat")
      ).to eql expected_item
    end
  end

end
