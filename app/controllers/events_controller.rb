class EventsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]

  def index
    @active_page = params.fetch(:active_page, 0).to_i
    @active_events = Event.page_limit(@active_page).active_public.includes(:creator)
    @active_last_page = check_last_page(@active_events, 'active')
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
    params.require(:event).permit(:title, :description, :status, :location, :event_date, :active_page, :old_page, :close_page)
  end

  def check_last_page(list_events, type_event)
    list_events = list_events.to_a

    case type_event
    when 'close'
      last_event = Event.close_events.last
    when 'active'
      last_event = Event.where(status: 'public').last
    when 'old'
      last_event = Event.where("event_date < ?", DateTime.now).last
    end

    return true if list_events.include?(last_event)

    false
  end
end
