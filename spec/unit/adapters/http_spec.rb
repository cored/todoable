require "spec_helper"

RSpec.describe Todoable::Adapters::HTTP, :vcr do
  subject(:http_adapter) { described_class }

  describe ".with_credentials" do
    context "when passing invalid credentials" do
      let(:username) { "" }
      let(:password) { "" }

      it "throws an invalid credentials error" do
        expect {
          http_adapter.with_credentials(username: username, password: password)
        }.to raise_error(
          described_class::InvalidCredentials,
          /Please verify your username or password/
        )
      end
    end

    context "when passing valid credentials" do
    end
  end
end
