require "spec_helper"

RSpec.describe Todoable::Adapters::HTTP, :vcr do
  subject(:http_adapter) { described_class }
  let(:username) { ENV["API_USERNAME"] }
  let(:password) { ENV["API_PASSWORD"] }

  context "when http errors" do
    context "when passing invalid credentials" do
      let(:username) { "" }
      let(:password) { "" }

      it "throws an invalid credentials error" do
        expect {
          http_adapter
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
  end

  describe "#get" do
    it "enables get request against an API" do
      expect(
        http_adapter.with_credentials(
          username: username,
          password: password,
        ).get(url: "/api/lists")
      ).not_to be_empty
    end
  end

  describe "#post" do
    it "enables post request against an API" do
      expect(
        http_adapter.with_credentials(
          username: username,
          password: password,
        ).post(url: "/api/lists",
          params: { "list" => {"name" => "My new List"} }).keys
      ).to include("name", "id", "src")
    end
  end
end
