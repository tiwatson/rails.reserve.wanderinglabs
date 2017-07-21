class UsersController < ApplicationController
  before_action :login_required, only: [:show]

  def show
    render json: current_user
  end
end
