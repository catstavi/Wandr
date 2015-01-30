require 'rails_helper'

describe GoogleRequester do

  describe '#self.request' do
    context "you pass empty data" do
      it "raises an error that explains no data" do
        expect {GoogleRequester.request(nil)}.to raise_error
      end

    end
    context "you pass a name to search for" do
      it "saves the google-place id to the location" do
        Location.create(name: "The 5th Avenue Theatre", long: -122.333854660392, lat: 47.608847245574, desc: "Do you like musical theater? Do you like excellent...", active: true )
        GoogleRequester.request(Location.first)
        expect(Location.first.place_id).to be_a String
        expect(Location.first.place_id.empty?).to be false
      end
    end
  end

end
