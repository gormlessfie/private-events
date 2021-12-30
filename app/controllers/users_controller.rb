class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @events = current_user.events.includes(:creator)
  end
end
