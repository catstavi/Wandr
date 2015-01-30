class Location < ActiveRecord::Base
  has_many :windows
  validates :long, :lat, :name, presence: true

  def self.record_from_yelp(data)
    data.businesses.each do |bus|
      unless is_in_db?(bus)
        Location.create(name: bus.name, long: bus.location.coordinate.longitude,
                        lat: bus.location.coordinate.latitude,
                        active: !bus.is_closed, desc: bus.snippet_text)
      end
  end

  def is_in_db?(yelp_data)
    Location.find_by(name: yelp_data.name).empty? ? false : true
  end

end
