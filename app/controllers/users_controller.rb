class UsersController < ApplicationController

  def index
    @IP = request.remote_ip
  end

end
