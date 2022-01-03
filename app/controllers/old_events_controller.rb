class OldEventsController < ApplicationController
  def index
    @page = params.fetch(:page, 0).to_i
    @events = Event.page_limit(@page).past_events.includes(:creator)
    @type = 'old'
    @last_page = check_last_page(@events, @type)
  end
end
