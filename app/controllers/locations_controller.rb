class LocationsController < ApplicationController
  def browse
    # @data = YelpRequester.request(session[:user_lat], session[:user_long])
    # Location.record_from_yelp(@data)
    # @lat = session[:user_lat]
    # @long = session[:user_long]
    # @photo_hash = get_db_photos

    # scroll through photos loaded by db/api, javascript interactive
  end

  def show
    # this return the data that ajax will need to fill out the show information for that div
    loc = Location.find(params[:id].to_i)
    data = { name: loc.name, desc: loc.desc, lat: loc.lat, long: loc.long, user_lat: session[:user_lat], user_long: session[:user_long], google_link: loc.google_link, yelp_link: loc.yelp_link }
    render json: data
  end

  def index
    # this could be an admin oriented feature that lists all locations
  end

  def get_db_photos
    render json: Location.url_and_id_arry( session[:user_lat], session[:user_long] )
  end

  def check_for_new_locations
    #it checks for previously unsaved locations from yelp and updates already saved ones
    Location.record_new(session[:user_lat], session[:user_long])
    #it gets photos from database locations again(get_db_photos)
    get_db_photos

  end
end
