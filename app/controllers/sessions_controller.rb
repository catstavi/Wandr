class SessionsController < ApplicationController

  def geolocation
    session[:user_lat] = params[:latitude]
    session[:user_long] = params[:longitude]
    all_ok
  end

  def all_ok
    respond_to do |format|
      format.json { render json: :pineapple, status: :ok }
    end
  end

  def address_location
    address = params[:address]
    a=Geokit::Geocoders::GoogleGeocoder.geocode address
    session[:user_lat] = a.lat
    session[:user_lng] = a.lng
    all_ok
  end
end
