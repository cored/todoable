require "spec_helper"

RSpec.describe Todoable::Adapters::HTTP, :vcr do
  subject(:http_adapter) { described_class }
  let(:username) { ENV["API_USERNAME"] }
  let(:password) { ENV["API_PASSWORD"] }

  describe ".with_credentials" do
    context "when passing invalid credentials" do
      let(:username) { "" }
      let(:password) { "" }

      it "throws an invalid credentials error" do
        expect {
          http_adapter.with_credentials(username: username, password: password)
        }.to raise_error(
          described_class::InvalidCredentialsError,
          /Please verify your username or password/
        )
      end
    end
  end

  describe "#get" do
    it "enables get request against todoable API" do
      expect(
        http_adapter.with_credentials(
          username: username,
          password: password,
        ).get(url: "/api/lists")
      ).to eql([])
    end
  end
end
