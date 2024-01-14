module EventsHelper
    def show_remaining_events_count(events)
      remaining_count = events.size - 2
      remaining_count > 0 ? "+#{remaining_count}" : nil
    end
end
