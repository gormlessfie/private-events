class OldEventsController < ApplicationController
  def index
    @old_page = params.fetch(:old_page, 0).to_i
    @old_events = Event.page_limit(@old_page).past_events.includes(:creator)
    @old_last_page = check_last_page(@old_events, 'old')
  end
end
