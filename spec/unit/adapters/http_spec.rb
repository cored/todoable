require "spec_helper"

RSpec.describe Todoable::Adapters::HTTP, :vcr do
  subject(:http_adapter) do
    described_class.
      with_credentials(username: username, password: password)
  end
  let(:username) { ENV["TODOABLE_USERNAME"] }
  let(:password) { ENV["TODOABLE_PASSWORD"] }

  context "when http errors" do
    context "when passing invalid credentials" do
      let(:username) { "" }
      let(:password) { "" }

      specify do
        expect {
          described_class
            .with_credentials(
              username: username,
              password: password
          ).get(url: "/api/lists")
        }.to raise_error(
          described_class::InvalidCredentialsError,
          /Please verify your username or password/
        )
      end
    end

    context "when the returned resource its not valid" do
      specify do
        expect {
          http_adapter.get(url: "/api/list/id")
        }.to raise_error(
          described_class::UnprocessableEntityError,
          /Unprocessable entity/
        )
      end
    end
  end

  describe "#get" do
    it "enables get request against an API" do
      expect(
        http_adapter.get(url: "/api/lists")
      ).not_to be_empty
    end
  end

  describe "#post" do
    it "enables post request against an API" do
      expect(
        http_adapter.post(url: "/api/lists",
          params: { "list" => {"name" => "My new List"} })
      ).to match(
        a_hash_including({ "name" => "My new List"})
      )
    end
  end

  describe "#patch" do
    let(:list_to_update) do
      http_adapter.post(
        url: "/api/lists",
        params: { list: { name: "updating a list"} }
      )
    end

    it "enables patch request against an API" do
      expect(
        http_adapter.patch(url: "/api/lists/#{list_to_update["id"]}",
          params: { "list" => {"name" => "My new List"} })
      ).to match(
        a_hash_including({ "name" => "My new List"})
      )
    end
  end
end
