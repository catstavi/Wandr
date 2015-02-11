require 'rails_helper'

require 'vcr'

VCR.configure do |c|
  #the directory where your cassettes will be saved
  c.cassette_library_dir = 'spec/vcr_cassettes'
  # your HTTP request service. You can also use fakeweb, webmock, and more
  c.hook_into :webmock
  c.default_cassette_options = { :record => :new_episodes }
end


describe GoogleRequester do

  describe '#self.request' do

    let(:no_google_loc) { Location.create(name: "Betty Boo's Best Gallery", lat: 47, long: -122, city: "seattle", desc: "best gallery", active: true)}
    let(:fifth_ave) { Location.create(name: "The 5th Avenue Theatre", long: -122.333854660392, lat: 47.608847245574, desc: "Do you like musical theater? Do you like excellent...", city: "seattle", active: true ) }
    let(:troll) { Location.create(name: "Fremont Troll", long: -122.333854660392, lat: 47.608847245574, desc: "oooh it's a troll", city: "seattle", active: true ) }

    context "you pass a location object that is not in google systems" do
      it "sets the locations 'active' to false" do
        VCR.use_cassette 'google_by_query' do
          GoogleRequester.request(no_google_loc)
        end
        expect(no_google_loc.active).to be false
      end
    end

    context "you pass an object without an exact name match" do
      it "finds it and updates it's place_id" do
        VCR.use_cassette 'google_by_lat_long' do
          GoogleRequester.request(fifth_ave)
        end
        expect(fifth_ave.place_id).to eq("ChIJoT6vDbRqkFQRtTKgZ3GsZc0")
      end
    end

    context "you pass a loc with no hour information" do
      it "adds a place id and keeps it active" do
        VCR.use_cassette 'google_no_hourly' do
          GoogleRequester.request(troll)
        end
        expect(troll.place_id).to be_truthy
        expect(troll.active).to be_truthy
      end
    end
  end

  describe 'get_hours' do
    let(:fifth_ave) { Location.create(name: "The 5th Avenue Theatre", long: -122.333854660392, lat: 47.608847245574, desc: "Do you like musical theater? Do you like excellent...", city: "seattle", active: true, place_id: "ChIJoT6vDbRqkFQRtTKgZ3GsZc0" ) }
    let(:ave_windows) { Window.create(open_day: 1, close_day: 1, open_time: 0001, close_time: 0002, location_id: fifth_ave.id)
                        Window.create(open_day: 2, close_day: 2, open_time: 0001, close_time: 0002, location_id: fifth_ave.id)}

    it "changes hours_updated_at attr" do
      VCR.use_cassette 'google_loc_id_query' do
        GoogleRequester.get_hours(fifth_ave)
      end
      this_time = Time.now - 1.day
      expect(fifth_ave.hours_updated_at).to be > this_time
    end

    context "you pass a location with a place_id" do
      it "saves windows to that location" do
        VCR.use_cassette 'google_loc_id_query' do
          GoogleRequester.get_hours(fifth_ave)
        end
        expect(fifth_ave.windows).to_not be_empty
      end
    end

    context "you pass it a location with old windows" do
      it "deletes the old windows" do
        ave_windows
        VCR.use_cassette 'google_loc_id_query' do
          GoogleRequester.get_hours(fifth_ave)
        end
        expect(fifth_ave.windows.where(open_time: 1, close_time: 2)).to be_empty
      end
    end
  end
end
