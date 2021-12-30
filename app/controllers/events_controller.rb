class EventsController < ApplicationController
  def index
    @events = Event.all.includes(:creator)
  end
end
