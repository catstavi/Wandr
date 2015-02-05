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
    ###it queries yelp
    @data = YelpRequester.request(session[:user_lat], session[:user_long])
   ##it adds yelp results to db
    Location.record_from_yelp(@data)
   ##it gets photos from database locations again(get_db_photos)

    photos = get_db_photos
    photo_hash_array = []
    # new_hash = {}

    photos.keys.each do |key|
      photo_hash_array << { key => photos[key] }
    end
    photo_hash_array.shuffle!
    # new_hash = { "photos" => photo_hash_array.shuffle}
    respond_to do |format|
      format.json {render json: photo_hash_array }
    end

  end
end
