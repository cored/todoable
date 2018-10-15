require "spec_helper"

RSpec.describe Todoable::Client do
  subject(:todoable_client) do
    described_class.new(username: username,
                        password: password,
                        http_adapter: http_adapter)
  end
  let(:username) { "username" }
  let(:password) { "password" }
  let(:http_adapter) { instance_double "Adapters::HTTP" }

  describe "#lists" do
    context "when there are no lists created" do
      it "returns an empty collection" do
        expect(todoable_client.lists).to be_empty
      end
    end

    context "when there are some lists created" do

    end
  end
end
