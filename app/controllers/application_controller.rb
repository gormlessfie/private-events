class ApplicationController < ActionController::Base
  def check_last_page(list_events, type_event)
    list_events = list_events.to_a

    case type_event
    when 'close'
      last_event = Event.public_events.close_events.last
    when 'active'
      last_event = Event.public_events.active_events.last
    when 'old'
      last_event = Event.public_events.past_events.first
    end

    return true if list_events.include?(last_event)

    false
  end
end
