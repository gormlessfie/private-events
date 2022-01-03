class CloseEventsController < ApplicationController
  def index
    @page = params.fetch(:page, 0).to_i
    @events = Event.page_limit(@page).public_events.close_events
                                     .includes(:creator).order(event_date: :asc)
    @type = 'close'
    @last_page = check_last_page(@events, @type)
  end
end
