class YelpRequester


  def self.request(lat, long)
    coordinates = { latitude: lat, longitude: long }
    filter = {
      category_filter: 'arts',
      sort: 1
    }
    Yelp.client.search_by_coordinates(coordinates, filter)

    # respond_to do |format|
    #   format.json { render json: x, status: :ok }
    # end
  end

end
