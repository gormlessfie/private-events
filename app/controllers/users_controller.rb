class UsersController < ApplicationController

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @events = @user.events.includes(:creator)

    @attending_events = Event.where(id: UsersEvent.select(:event_id).where(user: @user))
    @public_events = @user.events.where(status: 'public')
  end
end
