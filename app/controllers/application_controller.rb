class ApplicationController < ActionController::Base
  def check_last_page(list_events, type_event)
    list_events = list_events.to_a

    case type_event
    when 'close'
      last_event = Event.close_events.last
    when 'active'
      last_event = Event.active_public.last
    when 'old'
      last_event = Event.past_events.last
    end

    return true if list_events.include?(last_event)

    false
  end
end
