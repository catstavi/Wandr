class SessionsController < ApplicationController

  def geolocation
    session[:user_lat] = params[:latitude]
    session[:user_long] = params[:longitude]
    all_ok
  end

  def address_location
    # use this fake place to test the sorry div
    # session[:user_lat] = 42.191954
    # session[:user_long] = -108.450101
    # all_ok
    a = Geokit::Geocoders::GoogleGeocoder.geocode params[:address]
    if a.success
      session[:user_lat] = a.lat
      session[:user_long] = a.lng
      all_ok
    else
      render json: :nono {error: "Unable to interpret address.", status: 404 }, status: 404
    end
  end

  private

  def all_ok
    respond_to do |format|
      format.json { render json: :pineapple, status: :ok }
    end
  end

  def address_not_found

  end

end
