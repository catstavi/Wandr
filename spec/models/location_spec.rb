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
      loc1
      loc2
      loc4
      win2
      win3
      loc3.windows.each do |win|
        puts win.open_day, win.close_day, win.open_time, win.close_time
      end
      timezone = Timezone::Zone.new :latlon => [47, -122]
      time_now = timezone.time Time.now
      time_now_int =  time_now.hour*100 + time_now.min
      day_int = time_now.strftime("%w").to_i
      puts "$$$$$$$$$$$$$"
      puts Location.includes(:windows).where("(locations.id NOT IN (SELECT DISTINCT(location_id) FROM windows)) OR (open_day = ? AND open_time <= ? OR close_day = ? AND close_time > ?)", day_int, time_now_int, day_int, time_now_int).references(:windows)
      puts "$$$$$$$$$$$$$"
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

    it "remove locations that are closed" do
      win3
      expect(Location.filtered(47.6216643, -122.32132559999998)).to include loc3
    end

  end

end
