class SessionsController < ApplicationController

  def geolocation
    session[:user_lat] = params[:latitude]
    session[:user_long] = params[:longitude]
    all_ok
  end

  def address_location
    address = params[:address]
    a=Geokit::Geocoders::GoogleGeocoder.geocode address
    session[:user_lat] = a.lat
    session[:user_long] = a.lng
    respond_to do |format|
      format.html {render html: "pineapple"}
      format.js
    end
  end

  private

  def all_ok
    respond_to do |format|
      format.json { render json: :pineapple, status: :ok }
    end
  end

end
