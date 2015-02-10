require 'rails_helper'

describe Location do

  describe '#switch_off' do

    let(:loc) {Location.create(name: 'bob', lat: 1, long: 2, active: true) }

    it 'changes active to false' do
      loc.switch_off
      expect(loc.active).to be false
    end
    context "location is already not active" do
      it "still changes updated_at" do
        old_time = Time.now - 1.day
        loc.update(active: false, updated_at: old_time)
        loc.switch_off
        expect(loc.updated_at).to be > old_time
      end
    end
  end

  describe '#self.near' do
    # nearby and active, no hours
    let(:loc1) { Location.create(name: "The 5th Avenue Theatre", long: -122.333854660392, lat: 47.608847245574, desc: "Do you like musical theater? Do you like excellent...", city: "seattle", active: true ) }
    # not nearby, and not active, open all the time
    let(:loc2) { Location.create( name: "Rock Box", long: -122, lat: 47, desc: "Had a great time there with my friends!\nThe time d...", city: "seattle", active: false)}
    let(:win2) { Window.create(open_day: 0, close_day: 0, open_time: 0001, close_time: 2359, location_id: loc2.id)
                Window.create(open_day: 1, close_day: 1, open_time: 0001, close_time: 2359, location_id: loc2.id)
                Window.create(open_day: 2, close_day: 2, open_time: 0001, close_time: 2359, location_id: loc2.id)
                Window.create(open_day: 3, close_day: 3, open_time: 0001, close_time: 2359, location_id: loc2.id)
                Window.create(open_day: 4, close_day: 4, open_time: 0001, close_time: 2359, location_id: loc2.id)
                Window.create(open_day: 5, close_day: 5, open_time: 0001, close_time: 2359, location_id: loc2.id)
                Window.create(open_day: 6, close_day: 6, open_time: 0001, close_time: 2359, location_id: loc2.id)
      }
    # nearby and active, but always closed
    let(:loc3) {  Location.create(name: "John John's Game Room", long: -122.327515, lat: 47.616615, desc: "Gotta love it here! The vibe is cool, the drinks a...", active: true)}
    let(:win3) { Window.create(open_day: 0, close_day: 0, open_time: 0001, close_time: 0002, location_id: loc3.id)
                Window.create(open_day: 1, close_day: 1, open_time: 0001, close_time: 0002, location_id: loc3.id)
                Window.create(open_day: 2, close_day: 2, open_time: 0001, close_time: 0002, location_id: loc3.id)
                Window.create(open_day: 3, close_day: 3, open_time: 0001, close_time: 0002, location_id: loc3.id)
                Window.create(open_day: 4, close_day: 4, open_time: 0001, close_time: 0002, location_id: loc3.id)
                Window.create(open_day: 5, close_day: 5, open_time: 0001, close_time: 0002, location_id: loc3.id)
                Window.create(open_day: 6, close_day: 6, open_time: 0001, close_time: 0002, location_id: loc3.id)
      }
    context 'location are within 2 miles of lat & long' do
      it "returns the locations" do
        # why doesn't this work when I assign Locations.near to a variable?
        # the variable only gets one location. wat.
        expect(Location.near(47.6216643, -122.32132559999998) ).to include loc1
        expect(Location.near(47.6216643, -122.32132559999998) ).to_not include loc2
      end
    end

    context 'locations are not within 2 miles of lat & long' do
      it 'does not return those locations' do
        expect(Location.near(47, -122) ).to_not include loc1
        expect(Location.near(47, -122) ).to include loc2
      end
    end

  describe "#active" do
    it 'returns only active locations' do
      expect(Location.active).to include loc1
      expect(Location.active).to_not include loc2
    end
  end

  describe "#open_now_or no_hours" do
    it "returns a location that is open now" do
      win2
      expect(Location.open_now_or_no_hours(47, -122)).to include loc2
    end

    it "returns a location that has no hourly info/windows" do
      expect(Location.open_now_or_no_hours(47, -122)).to include loc1
    end

    it "does not return a location that is closed now" do
      win3
      expect(Location.open_now_or_no_hours(47, -122)).to_not include loc3
    end

  end
end

  #
  # let(:burst) {BurstStruct::Burst.new({:businesses => [{name: "bob", location: {coordinate: {latitude: 2, longitude: 5}, city: "Seattle"}, snippet_text: "this is bobs bobs", is_closed: false}]})}
  #
  # context 'we give it a BurstStruct with lat, long, name, snippet' do
  #   it 'creates as many locations as are in the businesses array of the burst' do
  #     Location.record_from_yelp(burst)
  #     expect(Location.all.count).to eq 1
  #   end
  # end
  #
  # context 'the location with that name already exists in the model' do
  #   it "it doesn't create a new location" do
  #     Location.create(name: 'bob', lat: 1, long: 2)
  #     Location.record_from_yelp(burst)
  #     expect(Location.all.count).to eq 1
  #   end
  # end
end
