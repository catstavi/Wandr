class Location < ActiveRecord::Base
  has_many :windows
  validates :long, :lat, :name, presence: true

  def self.record_from_yelp(data)
    data.businesses.each do |bus|
      Location.create(name: loc["name"], long: loc["location"]["coordinate"]["longitude"],
                      lat: loc["location"]["coordinate"]["latitude"],
                      active: true, desc: loc["snippet_text"])
    end
  end
end
