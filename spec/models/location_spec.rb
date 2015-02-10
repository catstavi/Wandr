require 'rails_helper'

describe Location do
  # nearby and active, no hours
  let(:loc1) { Location.create(name: "The 5th Avenue Theatre", long: -122.333854660392, lat: 47.608847245574, desc: "Do you like musical theater? Do you like excellent...", city: "seattle", active: true ) }
  # nearby, and not active, open all the time
  let(:loc2) { Location.create( name: "Rock Box", long: -122.333854660392, lat: 47.608847245574, desc: "Had a great time there with my friends!\nThe time d...", city: "seattle", active: false)}
  let(:win2) { Window.create(open_day: 0, close_day: 0, open_time: 0001, close_time: 2359, location_id: loc2.id)
              Window.create(open_day: 1, close_day: 1, open_time: 0001, close_time: 2359, location_id: loc2.id)
              Window.create(open_day: 2, close_day: 2, open_time: 0001, close_time: 2359, location_id: loc2.id)
              Window.create(open_day: 3, close_day: 3, open_time: 0001, close_time: 2359, location_id: loc2.id)
              Window.create(open_day: 4, close_day: 4, open_time: 0001, close_time: 2359, location_id: loc2.id)
              Window.create(open_day: 5, close_day: 5, open_time: 0001, close_time: 2359, location_id: loc2.id)
              Window.create(open_day: 6, close_day: 6, open_time: 0001, close_time: 2359, location_id: loc2.id)
    }
  # nearby and active, but always closed
  let(:loc3) {  Location.create(name: "John John's Game Room", long: -122.327515, lat: 47.616615, desc: "Gotta love it here! The vibe is cool, the drinks a...", active: true, city: "seattle")}
  let(:win3) { Window.create(open_day: 0, close_day: 0, open_time: 0001, close_time: 0002, location_id: loc3.id)
              Window.create(open_day: 1, close_day: 1, open_time: 0001, close_time: 0002, location_id: loc3.id)
              Window.create(open_day: 2, close_day: 2, open_time: 0001, close_time: 0002, location_id: loc3.id)
              Window.create(open_day: 3, close_day: 3, open_time: 0001, close_time: 0002, location_id: loc3.id)
              Window.create(open_day: 4, close_day: 4, open_time: 0001, close_time: 0002, location_id: loc3.id)
              Window.create(open_day: 5, close_day: 5, open_time: 0001, close_time: 0002, location_id: loc3.id)
              Window.create(open_day: 6, close_day: 6, open_time: 0001, close_time: 0002, location_id: loc3.id)
    }
    # not nearby, active, no hours
  let(:loc4) { Location.create(name: "A place", long: -122, lat: 47, desc: "Do you like musical theater? Do you like excellent...", city: "seattle", active: true ) }
  let(:loc5) { Location.create( name: "Test Box", long: -122.333854660392, lat: 47.608847245574, desc: "Had a great time there with my friends!\nThe time d...", city: "seattle", active: true)}
  let(:pic5) { Photo.create(url: "ex.url1", location_id: loc5.id)
              Photo.create(url: "ex.url2", location_id: loc5.id)
              Photo.create(url: "ex.url3", location_id: loc5.id)}

  describe '#switch_off' do

    it 'changes active to false' do
      loc1.switch_off
      expect(loc1.active).to be false
    end

    context "location is already not active" do
      it "still changes updated_at" do
        old_time = Time.now - 1.day
        loc1.update(active: false, updated_at: old_time)
        loc1.switch_off
        expect(loc1.updated_at).to be > old_time
      end
    end
  end

  describe '#self.near' do
    context 'location are within 2 miles of lat & long' do
      it "returns the locations" do
        # why doesn't this work when I assign Locations.near to a variable?
        # the variable only gets one location. wat.
        expect(Location.near(47.6216643, -122.32132559999998) ).to include loc1
        expect(Location.near(47.6216643, -122.32132559999998) ).to_not include loc4
      end
    end

    context 'locations are not within 2 miles of lat & long' do
      it 'does not return those locations' do
        expect(Location.near(47, -122) ).to_not include loc1
        expect(Location.near(47, -122) ).to include loc4
      end
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

  describe "#filtered" do
    it "returns locations that are active, near, and open/no hours" do
      expect(Location.filtered(47.6216643, -122.32132559999998)).to include loc1
    end

    it "removes locations that are not active" do
      expect(Location.filtered(47.6216643, -122.32132559999998)).to_not include loc2
    end

    it "removes locations that are not near" do
      expect(Location.filtered(47.6216643, -122.32132559999998)).to_not include loc4
    end

    it "removes locations that are closed" do
      win3
      expect(Location.filtered(47.6216643, -122.32132559999998)).to_not include loc3
    end

  end

  describe "#url_and_id_arry" do
    it "returns an array full of hashes" do
      loc5
      pic5
      ar = Location.url_and_id_arry(47.6216643, -122.32132559999998)
      expect(ar).to be_a Array
      expect(ar[0]).to be_a Hash
    end

    it "has photo urls as keys" do
      loc5
      pic5
      url = loc5.photos.first.url
      ar = Location.url_and_id_arry(47.6216643, -122.32132559999998)
      keys = ar.collect {|hash| hash.keys}
      expect(keys.flatten).to include url
    end

    it "has location id as hash values" do
      loc5
      pic5
      ar = Location.url_and_id_arry(47.6216643, -122.32132559999998)
      expect(ar.first.values).to include loc5.id
    end

  end

end
