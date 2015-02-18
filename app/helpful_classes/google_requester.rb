class GoogleRequester

  def self.check_for_updates(location)

    if location.hours_updated_at < Time.now - 2.weeks
      if location.place_id == nil
        request(location)
      else
        get_hours_and_desc(location, GooglePlaces::Client.new(ENV["GOOGLE_PLACE_KEY"]) )
      end
    end
  end

  def self.request(location)
    client = GooglePlaces::Client.new(ENV["GOOGLE_PLACE_KEY"])
    loc_arry = client.spots(location.lat, location.long, :name => location.name)
      # add second search if first returns nothing using spots_by_query and city name
    if loc_arry.empty? then loc_arry = client.spots_by_query("#{location.name} in #{location.city}") end
    if loc_arry.empty?
      location.update( active: false, hours_updated_at: Time.now )
    else
      # save google place ID
      location.update(place_id: loc_arry[0].place_id, active: true, hours_updated_at: Time.now)
      #save hours in association with location
      # unless loc_arry[0].opening_hours == nil
        get_hours_and_desc(location, client)
      # end
    end
  end

# maybe check # of calls left today??
  def self.get_desc(location, loc_data)
    unless loc_data.reviews.empty?
      review_text = loc_data.reviews.collect { |rev| rev.text }
      text = review_text.join(" ") + location.desc
      text = text.strip.gsub(/[^A-Za-z0-9\s]/, '')
      response = HTTParty.post("https://textanalysis.p.mashape.com/textblob-noun-phrase-extraction",
          :headers => { 'X-Mashape-Key' => ENV["MASHAPE_KEY"] } ,
          :body => "text= #{text}")
      nouns = response.parsed_response["noun_phrases"].uniq
      location.update(desc: nouns.join(", "))
    end
  end

  def self.get_link(location, loc_data)
    unless loc_data.url == nil
      location.update(google_link: loc_data.url)
    end
  end

  def self.get_hours_and_desc(location, client)
    loc_data = client.spot(location.place_id)
    hours = loc_data.opening_hours
    get_link(location, loc_data)
    get_desc(location, loc_data)
    unless hours == nil
      # clear out any old windows before building new ones
      location.windows.destroy_all
      unless hours["periods"] == [{"open"=>{"day"=>0, "time"=>"0000"}}]
        # if this is true, location is open 24 hrs, save no windows
        hours["periods"].each do |day_hash|
          location.windows << Window.create(open_day: day_hash["open"]["day"],
                                          open_time: day_hash["open"]["time"],
                                          close_day: day_hash["close"]["day"],
                                          close_time: day_hash["close"]["time"])
        end
      end
    end
    location.update(hours_updated_at: Time.now)
  end

end
