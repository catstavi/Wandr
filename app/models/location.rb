class Location < ActiveRecord::Base
  has_many :windows
  has_many :insta_codes
  validates :long, :lat, :name, presence: true
  acts_as_mappable :default_units => :miles,
                   :default_formula => :sphere,
                   :distance_field_name => :distance,
                   :lat_column_name => :lat,
                   :lng_column_name => :long


  def self.record_from_yelp(data)
    data.businesses.each do |bus|
      location = Location.find_by(name: bus.name)
      if !location.nil?
        GoogleRequester.check_for_updates(location)
      else
        new_locale = Location.create(name: bus.name, long: bus.location.coordinate.longitude,
                                     lat: bus.location.coordinate.latitude,
                                     active: !bus.is_closed, desc: bus.snippet_text,
                                     city: bus.location.city)
        GoogleRequester.request(new_locale)
      end
    end
  end

  def self.by_location(lat, long)
    #maybe have a way to only return a certain #, sorted by closest?
    #plus only the ones that are open?
    within(2, origin: [lat, long])
  end

end
