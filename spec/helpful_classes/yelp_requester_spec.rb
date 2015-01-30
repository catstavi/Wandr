require 'rails_helper'

describe YelpRequester do
  describe '#self.request'
    context "there is no data passed" do
      it "raises an error that explains no data" do
        expect { YelpRequester.request(nil, nil) }.to raise_error
      end
    end

    context "there is legit data passed" do
      it "returns a BurstStruct::Burst Object" do
        expect(YelpRequester.request(47.618517,-122.335852)).to be_a BurstStruct::Burst
      end
    end
  end
