require 'rails_helper'

describe InstagramRequester do
  let(:cal_and) {Location.create(name: "Cal Anderson Park", long: -122.31909753016, lat: 47.617947324051, desc: "This is my absolute favorite Park in Capitol Hill....", active: true, created_at: "2015-02-07 23:28:09", updated_at: "2015-02-08 23:44:37", place_id: "ChIJP4h3szIVkFQRRmqfQ_FNnuM", city: "Seattle", insta_codes_updated_at: "2015-02-07 23:28:10", photos_updated_at: "2015-02-08 23:44:37", hours_updated_at: "2015-02-07 23:28:09") }
  let(:cal_codes) {InstaCode.create(code: "401578185", location_id: cal_and.id)
                  InstaCode.create(code: "3316990", location_id: cal_and.id) }
  let(:betty_boo) { Location.create(name: "Betty Boo's Best Gallery", lat: 47, long: -122, city: "seattle", desc: "best gallery", active: true) }
  let(:troll) { Location.create(name: "Fremont Troll", lat: 47.651034, long: -122.347323, desc: "oooh it's a troll", city: "seattle", active: true, place_id: "ChIJvYSnKAEVkFQR35lxzvEE250" ) }
  describe '#find_insta_codes' do
    context "location has no instacodes associated with it" do
      context "location can be found in instagram" do
        it "saves one or more instacode models to the db" do
          VCR.use_cassette 'instagram_troll_codes' do
            InstagramRequester.find_insta_codes(troll)
          end
          expect(troll.insta_codes).to_not be_empty
        end
      end

      context "location cannot be found in instagram" do
        it "switches the location off" do
          VCR.use_cassette 'instagram_betty_boo_codes' do
            InstagramRequester.find_insta_codes(betty_boo)
          end
          expect(betty_boo.active).to be false
        end
      end

      context "a location has already had insta_codes check in last two weeks" do
        it "does not check again" do
          troll.update(insta_codes_updated_at: Time.now)
          InstagramRequester.find_insta_codes(troll)
          expect(troll.insta_codes).to be_empty
        end
      end
    end
  end

  describe '#photos_by_instacode' do
    it "returns an array of url strings" do
      response = VCR.use_cassette 'instagram_photo_query' do
        InstagramRequester.photos_by_instacode("158440")
      end
      expect(response).to be_a Array
      expect(response.first).to be_a String
    end
  end

  describe '#save_photos_by_location' do
    it "saves photos from each insta_code on a location" do
      cal_codes
      VCR.use_cassette 'instagram_cal_anderson' do
        InstagramRequester.save_photos_by_location(cal_and)
      end
      expect(cal_and.photos).to_not be_empty
    end

  end
  # describe 'photos_by_instacode' do
  #   context "pass a valid instacode" do
  #     it "returns an array of strings" do
  #       photos = InstagramRequester.photos_by_instacode("312252802")
  #       expect(photos).to be_a Array
  #       expect(photos.last).to be_a String
  #     end
  #   end
  # end
  #
  # describe 'find_locations' do
  #   context "location has no insta_codes associated with it" do
  #     it "searches instagram for locations" do
  #       loc = Location.create(name: "The Tasting Room", lat: "47.6104813", long: "-122.3424683")
  #       InstagramRequester.find_locations(loc)
  #       expect(InstaCode.all.count).to be > 0
  #     end
  #   end
  #
  #   context "location has insta_codes associated with it" do
  #     it "doesn't create new insta_codes" do
  #       loc = Location.create(name: "The Tasting Room", lat: "47.6104813", long: "-122.3424683")
  #       InstaCode.create(code: "123", location_id: loc.id)
  #
  #       expect {
  #         InstagramRequester.find_locations(loc)
  #       }.to change { InstaCode.count}.by(0)
  #     end
  #   end
  # end

end
