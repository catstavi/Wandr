class Location < ActiveRecord::Base

  has_many :windows
  has_many :insta_codes
  has_many :photos

  validates :long, :lat, :name, :city, presence: true
  validates :long, :lat, :name, presence: true

  acts_as_mappable :default_units => :miles,
                   :default_formula => :sphere,
                   :distance_field_name => :distance,
                   :lat_column_name => :lat,
                   :lng_column_name => :long

  def switch_off
    update(active: false, updated_at: Time.now)
  end

  # calls yelp for nearby locations
  #iterates over the results to either find them (and check for updates)
  # or create them, and get info from google places API

  def self.record_new(lat, long)
    data = YelpRequester.request(session[:user_lat], session[:user_long])
    data.businesses.each do |bus|
      location = Location.find_by(name: bus.name)
      if location.nil?
        new_locale = Location.create(name: bus.name, long: bus.location.coordinate.longitude,
                                     lat: bus.location.coordinate.latitude,
                                     active: !bus.is_closed, desc: bus.snippet_text,
                                     city: bus.location.city)
        GoogleRequester.request(new_locale)
      else
        # GoogleRequester will only query if location data is more than 2 weeks old
        GoogleRequester.check_for_updates(location)
        # InstagramRequester will only query if location data is more than 1 day old
        InstagramRequester.check_for_updates(location)
      end
    end
  end


  def self.by_location(lat, long)
    #maybe have a way to only return a certain #, sorted by closest?
    #plus only the ones that are open?
    #where is either active, or hasn't been updated for two weeks
    within(2, origin: [lat, long]).where("updated_at < ? OR active = ?", Time.now-2.weeks, true).first(10)
  end

end
