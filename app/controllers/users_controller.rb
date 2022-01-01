class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @events = @user.events.includes(:creator)
  end
end
