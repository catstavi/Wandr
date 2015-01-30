class GoogleRequester

  def self.request(location)
    @@client = GooglePlaces::Client.new(ENV["GOOGLE_PLACE_KEY"])
    if location == nil
      raise "Error: No search data provided for Google"
    else
      #make a google search using location.name
      loc_arry = @@client.spots(session[:user_lat], session[:user_long], :name => location.name)
      if loc_arry.is_empty
        location.active = false
      else
      # save google place ID
        location.update(place_id: loc_arry[0].place_id)
      #if lat & long are not close, switch active to false
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
