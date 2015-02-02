class Location < ActiveRecord::Base
  has_many :windows
  validates :long, :lat, :name, presence: true

  def self.record_from_yelp(data)
    data.businesses.each do |bus|
      location = Location.find_by(name: bus.name)
      if !location.nil?
        GoogleRequester.check_for_updates(location)
      else
        new_locale = Location.create(name: bus.name, long: bus.location.coordinate.longitude,
                                     lat: bus.location.coordinate.latitude,
                                     active: !bus.is_closed, desc: bus.snippet_text)
        GoogleRequester.request(new_locale)
      end
    end
  end

end
