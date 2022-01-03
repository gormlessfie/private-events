class EventsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]

  EVENTS_PER_PAGE = 2

  def index
    @active_page = params.fetch(:active_page, 0).to_i
    @old_page = params.fetch(:old_page, 0).to_i
    @close_page = params.fetch(:close_page, 0).to_i
  

    @active_events = Event.offset(@active_page * EVENTS_PER_PAGE).limit(EVENTS_PER_PAGE)
                          .includes(:creator).where(status: 'public')     
    @active_last_page = check_last_page(@active_events, 'active')

    @old_events = Event.offset(@old_page * EVENTS_PER_PAGE).limit(EVENTS_PER_PAGE)
                       .where("event_date < ?", DateTime.now)
    @old_last_page = check_last_page(@old_events, 'old')

    @close_events = Event.offset(@close_page * EVENTS_PER_PAGE).limit(EVENTS_PER_PAGE)
                         .where(event_date: DateTime.now..DateTime.now + 30.days)
    @close_last_page = check_last_page(@close_events, 'close')
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
      last_event = Event.where(event_date: DateTime.now..DateTime.now + 30.days).last
    when 'active'
      last_event = Event.where(status: 'public').last
    when 'old'
      last_event = Event.where("event_date < ?", DateTime.now).last
    end

    return true if list_events.include?(last_event)

    false
  end
end
