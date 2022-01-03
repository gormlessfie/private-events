class CloseEventsController < ApplicationController
  def index
    @close_page = params.fetch(:close_page, 0).to_i
    @close_events = Event.page_limit(@close_page).close_events.includes(:creator)
    @close_last_page = check_last_page(@close_events, 'close')
  end
end
