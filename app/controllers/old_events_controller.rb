class OldEventsController < ApplicationController
  def index
    @page = params.fetch(:page, 0).to_i
    @events = Event.page_limit(@page).public_events.past_events
                                     .includes(:creator).order(event_date: :desc)
    @type = 'old'
    @last_page = check_last_page(@events, @type)
  end
end
