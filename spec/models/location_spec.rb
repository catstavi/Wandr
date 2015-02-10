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
    let(:loc1) { Location.create(name: "The 5th Avenue Theatre", long: -122.333854660392, lat: 47.608847245574, desc: "Do you like musical theater? Do you like excellent...", city: "seattle", active: true )}
    let(:loc2) { Location.create( name: "Rock Box", long: -122.3202286, lat: 47.6156311, desc: "Had a great time there with my friends!\nThe time d...", city: "seattle", active: false)}

    context 'location are within 2 miles of lat & long' do
      it "returns the locations" do
        # why doesn't this work when I assign Locations.near to a variable?
        # the variable only gets one location. wat.
        expect(Location.near(47.6216643, -122.32132559999998) ).to include loc1
        expect(Location.near(47.6216643, -122.32132559999998) ).to include loc2
      end
    end

    context 'locations are not within 2 miles of lat & long' do
      it 'does not return those locations' do
        expect(Location.near(47, -122) ).to_not include loc1
        expect(Location.near(47, -122) ).to_not include loc2
      end
    end

  describe "#active" do
    it 'returns only active locations' do
      expect(Location.active).to include loc1
      expect(Location.active).to_not include loc2
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
