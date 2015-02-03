require 'rails_helper'

describe InstagramRequester do
  describe 'photos_by_instacode' do
    context "pass a valid instacode" do
      it "returns an array of strings" do
        photos = InstagramRequester.photos_by_instacode("312252802")
        expect(photos).to be_a Array
        expect(photos.last).to be_a String
      end
    end
  end

  describe 'find_locations' do
    context "location has no insta_codes associated with it" do
      it "searches instagram for locations" do
        loc = Location.create(name: "The Tasting Room", lat: "47.6104813", long: "-122.3424683")
        InstagramRequester.find_locations(loc)
        expect(InstaCode.all.count).to be > 0
      end
    end

    context "location has insta_codes associated with it" do
      it "doesn't create new insta_codes" do
        loc = Location.create(name: "The Tasting Room", lat: "47.6104813", long: "-122.3424683")
        InstaCode.create(code: "123", location_id: loc.id)

        expect {
          InstagramRequester.find_locations(loc)
        }.to change { InstaCode.count}.by(0)
      end
    end
  end

end
