require 'rails_helper'

describe GoogleRequester do

  describe '#self.request' do

    context "you pass a name to search for" do
      it "saves the google-place id to the location" do
        Location.create(name: "The 5th Avenue Theatre", long: -122.333854660392, lat: 47.608847245574, desc: "Do you like musical theater? Do you like excellent...", city: "seattle", active: true )
        GoogleRequester.request(Location.first)
        expect(Location.first.place_id).to be_a String
        expect(Location.first.place_id.empty?).to be false
      end

      it "makes some window rows" do
        Location.create(name: "The 5th Avenue Theatre", long: -122.333854660392, lat: 47.608847245574, desc: "Do you like musical theater? Do you like excellent...", city: "seattle", active: true )
        GoogleRequester.request(Location.first)
        expect(Location.first.windows.count).to be > 0
      end
    end

    context "you pass a name to search for" do
      it "is a recently updated location with a place id" do
        Location.create(name: "The 5th Avenue Theatre", long: -122.333854660392, lat: 47.608847245574, desc: "Do you like musical theater? Do you like excellent...", city: "seattle", active: true )
        GoogleRequester.request(Location.first)
        expect(Location.first.windows.count).to be > 0
      end
    end

    context "the google api doesn't have hours" do
      it "doesn't create any window rows" do
        Location.create(name: "The Fremont Troll", long: -122.347323, lat: 47.651034, city: "seattle")
        GoogleRequester.request(Location.first)
        expect(Location.first.windows.count).to be 0
      end
    end
  end

end
