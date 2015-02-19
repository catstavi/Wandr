class Location < ActiveRecord::Base

  has_many :windows
  has_many :insta_codes
  has_many :photos

  validates :long, :lat, :name, :city, presence: true

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
  def self.record_new(lat, long, offset)
    data = YelpRequester.request(lat, long, offset)
    data.businesses.each do |bus|
      location = Location.find_by(name: bus.name)
      if location.nil?
        cats = bus.categories.collect {|ar| ar.first}
        cats << bus.snippet_text
        cats = cats.join(" ")
        new_locale = Location.create(name: bus.name, long: bus.location.coordinate.longitude,
                                     lat: bus.location.coordinate.latitude,
                                     active: !bus.is_closed, desc: cats,
                                     city: bus.location.city, yelp_link: bus.mobile_url)
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

  def self.filtered(lat, long)
    data = []
    if Location.near(lat,long, 20).count > 5
      i = 2
      while data.count < 5 && i < 30
        data = Location.active.near(lat,long, i).open_now_or_no_hours(lat, long)
        i += 2
      end
    end
    data
  end

  def self.near(lat, long, distance)
    Location.within(distance, origin: [lat, long])
  end

  def self.open_now_or_no_hours(lat, long)
    timezone = Timezone::Zone.new :latlon => [lat, long]
    time_now = timezone.time Time.now
    time_now_int =  time_now.hour*100 + time_now.min
    day_int = time_now.strftime("%w").to_i
    Location.includes(:windows).where("(locations.id NOT IN (SELECT DISTINCT(location_id) FROM windows)) OR ( open_day = ? AND ( (open_day = close_day AND open_time < ? AND close_time > ?) OR (open_day != close_day AND open_time < ?) ) OR ( close_day = ? AND open_day != close_day AND close_time > ? ))", day_int, time_now_int, time_now_int, time_now_int, day_int, time_now_int).references(:windows)
  end

  def self.distance_hash(locs, lat, long)
    # builds a hash of location id to its distance from you
    user_loc = Geokit::LatLng.new(lat, long)
    dist_hash = {}
    locs.each do |loc|
      dist_hash[loc.id] = loc.distance_to(user_loc).round(2)
    end
    dist_hash
  end

  def self.filtered_location_details(lat, long)
    locs = filtered(lat,long)
    dist_hash = distance_hash(locs, lat, long)
    arry = locs.collect do |loc|
      loc.photos.last(10).collect do |photo|
        { url: photo.url, id: loc.id, name: loc.name, desc: loc.desc, google_link: loc.google_link, yelp_link: loc.yelp_link, lat: loc.lat, long: loc.long, user_lat: lat, user_long: long, distance: dist_hash[loc.id] }
      end
    end
    arry.flatten.shuffle
  end

end
