class YelpRequester


  def self.request(lat, long)
    if lat ==nil || long == nil
      raise "Error: Lat and/or Long provided are nil"
    else
      coordinates = { latitude: lat, longitude: long }
      filter = {
        category_filter: 'arts',
        sort: 1
      }
      Yelp.client.search_by_coordinates(coordinates, filter)
    end

  end

end
