class EventsController < ApplicationController
  before_action :authenticate_user!, only: [ :new, :create ]

  def index
    @events = Event.all.includes(:creator)
  end

  def show
    @event = Event.find(params[:id])
  end

  def new
    @user = current_user
    @event = @user.events.build
  end

  def create
    @user = current_user
    @event = @user.events.build(event_params)

    if @event.save
      flash[:notice] = 'Event created.'
      redirect_to user_event_path(@user, @event)
    else
      flash[:alert] = 'Event cannot be created.'
      render :new
    end
  end

  private

  def event_params
    params.require(:event).permit(:title, :description, :event_date)
  end
end
