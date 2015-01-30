require 'rails_helper'

describe GoogleRequester do

  describe '#self.request' do
    context "you pass empty data" do
      it "raises an error that explains no data" do
        expect {GoogleRequester.request(nil)}.to raise_error
      end

    end
    context "you pass a name to search for" do
      it "saves the google-place id & hours to the database" do

      end
    end
  end

end
