class UsersEventsController < ApplicationController
  before_action :authenticate_user!

  def create
    @event = Event.find(users_event_params[:event_id])
    @invitee = User.find_by('username = ?', users_event_params[:username])
    @invitation = @event.users_events.build(event: @event, user: @invitee)

    already_invited = UsersEvent.exists?(user: @invitee, event: @event)
  
    if already_invited
      flash[:notice] = "#{@invitee.username} is already attending."
      return redirect_to user_event_path(@event.creator, @event)
    end

    if @invitation.save
      flash[:notice] = 'Invitation sent!'
      redirect_to user_event_path(@event.creator, @event)
    else
      flash[:warning] = "#{users_event_params[:username]} does not exist!"
      redirect_to user_event_path(@event.creator, @event)
    end
  end

  def destroy
    @invitation = UsersEvent.find(params[:id])
    event = Event.find(@invitation.event_id)
    @invitation.destroy

    redirect_to user_event_path(event.creator, event)
  end

  private

  def users_event_params
    params.require(:users_event).permit(:event_id, :username)
  end
end
