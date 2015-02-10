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
