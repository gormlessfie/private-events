class UsersEventsController < ApplicationController
  before_action :authenticate_user!

  def create
    @event = Event.find(users_event_params[:event_id])
    @invitee = User.find_by('username = ?', users_event_params[:username])
    @invitation = @event.users_events.build(event: @event, user: @invitee)

    if @invitation.save
      flash[:notice] = 'Invitation sent!'
      redirect_to user_event_path(@event.creator, @event)
    else
      flash[:warning] = 'User does not exist!'
      redirect_to user_event_path(@event.creator, @event)
    end
  end

  def destroy
  end

  private

  def users_event_params
    params.require(:users_event).permit(:event_id, :username)
  end
end
