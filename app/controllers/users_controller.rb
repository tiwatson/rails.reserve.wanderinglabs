class UsersController < ApplicationController
  #before_action :login_required, only: [:show]

  def show
    render json: ENV #current_user
  end
end
