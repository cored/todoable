require "spec_helper"

RSpec.describe Todoable::Resources::Lists do
  subject(:lists) do
    described_class.new(lists: [list])
  end
  let(:list) { Todoable::Resources::List.new(name: "For testing") }

  describe ".for" do
    context "when the list attributes does not contains data" do
      it "returns an empty collection" do
        expect(
          described_class.for({})
        ).to eql(described_class.new(lists: []))
      end
    end
  end

  describe "#find_by" do
    context "when some of the attributes on the list match with the criteria" do
      it "returns the list first list with the matching attributes" do
        expect(
          lists.find_by(name: "For testing")
        ).to eql list
      end
    end

    context "when none of the attributes on the list match with the criteria" do
      it "returns a no list" do
        expect(
          lists.find_by(name: "")
        ).to eql described_class::NoList.new
      end
    end
  end
end
