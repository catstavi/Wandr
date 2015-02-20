class PhotosController < ApplicationController

  def flag
    photo = Photo.find_by(url: params[:photo_url])
    photo.update(flags: photo.flags+1)
    render json: photo.flags
  end

end
