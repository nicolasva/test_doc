class AvailableService
  def initialize(date)
    @date = date
    @days = date..(date + 6.days)
    @range_open = Event.range_open(@days)
  end

  attr_reader :date, :range_open, :days

  def call
    array_dates
  end

  private
  def array_dates
    days.map do |day|
      range_opens = range_opens(day)
      slots = Array.new
      if range_opens.any?
        appointments_day = Event.appointments_day(day)
        slots = range_opens.each_with_object([]) do |opening, arr|
          time = opening.starts_at
          while time < opening.ends_at
            time_taken = appointments_day.any? do |appointment|
              appointment_end_time = appointment.ends_at - 1.minute
              time_range = appointment.starts_at.to_s(:short_time)..appointment_end_time.to_s(:short_time)
              time_range.cover?(time.to_s(:short_time))
            end

            arr << time.to_s(:short_time) unless time_taken
            time += 30.minutes
          end
          arr
        end
      end
      {
        date: day.to_date,
        slots: slots || []
      }
    end
  end

  def range_opens(day)
    range_opens = range_open.select do |opening|
      (opening.starts_at.to_date == day) ||
        (opening.starts_at.wday == day.wday && opening.weekly_recurring)
    end
  end
end
