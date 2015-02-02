require 'rails_helper'

describe Location do
  let(:burst) {BurstStruct::Burst.new({:businesses => [{name: "bob", location: {coordinate: {latitude: 2, longitude: 5}, city: "Seattle"}, snippet_text: "this is bobs bobs", is_closed: false}]})}

  context 'we give it a BurstStruct with lat, long, name, snippet' do
    it 'creates as many locations as are in the businesses array of the burst' do
      Location.record_from_yelp(burst)
      expect(Location.all.count).to eq 1
    end
  end

  context 'the location with that name already exists in the model' do
    it "it doesn't create a new location" do
      Location.create(name: 'bob', lat: 1, long: 2)
      Location.record_from_yelp(burst)
      expect(Location.all.count).to eq 1
    end
  end
end
