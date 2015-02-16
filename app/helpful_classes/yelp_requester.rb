class YelpRequester

  def self.request(lat, long, offset)
    categories = %w(s)
    if lat ==nil || long == nil
      raise "Error: Lat and/or Long provided are nil"
    else
      coordinates = { latitude: lat, longitude: long }
      filter = {
        category_filter: "aquariums,basketballcourts,beaches,bowling,boating,climbing,gokarts,gun_ranges,hiking,horsebackriding,hot_air_balloons,lakes,lasertag,mini_golf,paintball,parks,recreation,skatingrinks,skydiving,swimmingpools,tennis,zoos,arcades,galleries,gardens,movietheaters,jazzandblues,museums,musicvenues,observatories,opera,theater,planetarium,psychic_astrology,farmersmarket,tea,tours,poolhalls,karaoke,libraries,landmarks,bookstores,fleamarkets,vintage,antiques",
        sort: 1,
        offset: offset
      }
      Yelp.client.search_by_coordinates(coordinates, filter)
    end
  end

end
