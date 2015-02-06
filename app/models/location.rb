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

  # it finds some locations that we already have
  def self.record_new(lat, long)
    data = YelpRequester.request(lat, long)
    data.businesses.each do |bus|
      location = Location.find_by(name: bus.name)
      if location.nil?
        new_locale = Location.create(name: bus.name, long: bus.location.coordinate.longitude,
                                     lat: bus.location.coordinate.latitude,
                                     active: !bus.is_closed, desc: bus.snippet_text,
                                     city: bus.location.city,
                                     hours_updated_at: Time.now,
                                     insta_codes_updated_at: Time.now,
                                     photos_updated_at: Time.now )
        GoogleRequester.request(new_locale)
        InstagramRequester.save_photos_by_location(new_locale)
      else
        # GoogleRequester will only query if hours location data is more than 2 weeks old
        GoogleRequester.check_for_updates(location)
        # InstagramRequester will only query if photo location data is more than 1 day old
        InstagramRequester.check_for_updates(location)
      end
    end
  end

  scope :active, -> { where(active: true) }
  # scope :open_now -> { joins(:windows).where("open_day = ? AND open_time <= ? OR close_day = ? AND close_time > ?", Time.now.day, time_now, Time.now.day, time_now) }
  # scope :no_hours, -> { where('locations.id NOT IN (SELECT DISTINCT(location_id) FROM windows)') }

<<<<<<< HEAD
  # def self.open_by_location(lat, long)
  def self.by_location(lat, long)
    #maybe have a way to only return a certain #, sorted by closest?
    #plus only the ones that are open?
    #where is either active, or hasn't been updated for two weeks
    within(2, origin: [lat, long]).where("updated_at < ? OR active = ?", Time.now-2.weeks, true).first(10)
=======
  def self.filtered(lat, long)
    Location.active.near(lat,long).open_now_or_no_hours
  end

  def self.near(lat, long)
    Location.within(2, origin: [lat, long])
>>>>>>> origin/save-urls
  end

  def self.open_now_or_no_hours
    time_now = Time.now.hour*100 + Time.now.min
    Location.joins(:windows).where("(locations.id NOT IN (SELECT DISTINCT(location_id) FROM windows)) OR (open_day = ? AND open_time <= ? OR close_day = ? AND close_time > ?)", Time.now.day, time_now, Time.now.day, time_now)
  end

  def self.url_and_id_arry(lat, long)
    arry = filtered(lat, long).collect do |loc|
      loc.photos.collect do |photo|
        { photo.url => loc.id }
      end
    end
    arry.flatten.shuffle
  end

end
