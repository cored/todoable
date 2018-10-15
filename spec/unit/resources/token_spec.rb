require "timecop"
require "spec_helper"

RSpec.describe Todoable::Resources::Token do
  describe "#valid?" do
    context "when token is empty" do
      subject(:token) do
        described_class.new(token: "", expires_at: DateTime.parse("2018-10-15 10:30"))
      end

      specify do
        expect(token).to_not be_valid
      end
    end

    context "when token has expire" do
      subject(:token) do
        described_class.new(
          token: "token",
          expires_at: DateTime.parse("2018-10-15 9:40")
        )
      end

      specify do
        Timecop.freeze(DateTime.parse("Oct 15 2018 10:00")) do
          expect(token).to_not be_valid
        end
      end
    end
  end
end
