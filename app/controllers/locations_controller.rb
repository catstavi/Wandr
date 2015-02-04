class LocationsController < ApplicationController
  def browse
    # @data = YelpRequester.request(session[:user_lat], session[:user_long])
    # Location.record_from_yelp(@data)
    @lat = session[:user_lat]
    @long = session[:user_long]
    @photo_hash = get_db_photos

    # scroll through photos loaded by db/api, javascript interactive
  end

  def show
    # this will be the location detail page with button to navigate here
  end

  def index
    # this could be an admin oriented feature that lists all locations
  end

  def get_db_photos
    InstagramRequester.photos_by_user_location(session[:user_lat], session[:user_long])
  end

  def check_for_new_locations

  end
end
