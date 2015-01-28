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

  def yelp_request
    coordinates = { latitude: params[:latitude], longitude: params[:longitude] }
    filter = {
      category_filter: 'arts',
      radius_filter: 4000,
      sort: 1
    }
    x  = Yelp.client.search_by_coordinates(coordinates, filter)

    respond_to do |format|
      format.json { render json: x, status: :ok }
    end

  end

end
