class EventsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]

  def index
    @page = params.fetch(:page, 0).to_i
    @events = Event.page_limit(@page).active_events.public_events
                                     .includes(:creator).order(event_date: :asc)
    @type = 'active'
    @last_page = check_last_page(@events, @type)
  end

  def show
    @event = Event.find(params[:id])
    @attendees = @event.attendees.includes(:users_events)
    @invitation = @event.users_events.build
    
    @already_invited = UsersEvent.exists?(event: @event, user: current_user)

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

  def edit
    @user = current_user
    @event = Event.find(params[:id])
  end

  def update
    @event = Event.find(params[:id])

    if @event.update(event_params)
      flash[:notice] = 'Event updated.'
      redirect_to user_event_path(@event.creator, @event)
    else
      render :edit
    end

  end

  def destroy
    @event = Event.find(params[:id])
    @event.destroy
    flash[:success] = 'Event deleted.'
    redirect_to user_path(current_user)
  end

  private

  def event_params
    params.require(:event).permit(:title, :description, :status, :location, :event_date, :page)
  end
end
