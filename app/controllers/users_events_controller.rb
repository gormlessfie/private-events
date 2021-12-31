class UsersEventsController < ApplicationController
  before_action :authenticate_user!

  def create
    @event = Event.find(params[:event_id])
    p @event
  end

  def destroy
  end

  private

  def users_event_params
    params.require(:users_event).permit(:username)
  end
end
