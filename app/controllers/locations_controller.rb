class LocationsController < ApplicationController
  def browse

  end

  def show
    # this return the data that ajax will need to fill out the show information for that div
    @location = Location.find(params[:id].to_i)
    data = { name: @location.name, desc: @location.desc }
    render json: data
  end

  def index
    # this could be an admin oriented feature that lists all locations
  end

  def get_db_photos
    render json: Location.url_and_id_arry( session[:user_lat], session[:user_long] )
  end

  def check_for_new_locations
    # offset the yelp query by 20 or more
    offset = params[:offset]
    #it checks for previously unsaved locations from yelp and updates already saved ones
    Location.record_new(session[:user_lat], session[:user_long], offset)
    #it gets photos from database locations again(get_db_photos)
    get_db_photos
  end

end
