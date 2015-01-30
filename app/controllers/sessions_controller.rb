class SessionsController < ApplicationController

  def set_location
    session[:user_lat] = params[:latitude]
    session[:user_long] = params[:longitude]
    respond_to do |format|
      format.json { render json: :pineapple, status: :ok }
    end
  end
end
