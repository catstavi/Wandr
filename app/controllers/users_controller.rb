class UsersController < ApplicationController

  def index
    coordinates = { latitude: 47.6088787, longitude: -122.3333011 }
    params = {
      category_filter: 'arts'
    }
    render json: Yelp.client.search_by_coordinates(coordinates, params)
  end

  def show

  end

end
