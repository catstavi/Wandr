class GoogleRequester

  def self.check_for_updates(location)
    if location.updated_at < Time.now - 2.weeks then request(location)
  end

  def self.request(location)
    @@client = GooglePlaces::Client.new(ENV["GOOGLE_PLACE_KEY"])
    loc_arry = @@client.spots(location.lat, location.long, :name => location.name)
    if loc_arry.empty?
      location.active = false
    else
      # save google place ID
      location.update(place_id: loc_arry[0].place_id)
      #save hours in association with location
      unless loc_arry[0].opening_hours == nil
        get_hours(location)
      end
    end
  end

  def self.get_hours(location)
    hours = @@client.spot(location.place_id).opening_hours["periods"]
    hours.each do |day_hash|
      Window.create(location_id: location.id, open_day: day_hash["open"]["day"],
                    open_time: day_hash["open"]["time"], close_day: day_hash["close"]["day"],
                    close_time: day_hash["close"]["time"])
    end
  end

end
