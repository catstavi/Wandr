class YelpRequester

  def yelp_request(params)
    coordinates = { latitude: params[:latitude], longitude: params[:longitude] }
    filter = {
      category_filter: 'arts',
      sort: 1
    }
    x  = Yelp.client.search_by_coordinates(coordinates, filter)

    respond_to do |format|
      format.json { render json: x, status: :ok }
    end

  end
end
