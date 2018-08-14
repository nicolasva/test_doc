class Event < ApplicationRecord
  scope :rdvs, -> { where(kind: 'appointment') }
  scope :opens, -> { where(kind: 'opening') }

  scope :range_open, ->(days) {
    opens.where(starts_at: days)
            .or(where('weekly_recurring = ? AND starts_at < ?', true, days.last.end_of_day))
  }

  scope :appointments_day, ->(day) {
    rdvs
      .where(starts_at: day.beginning_of_day..day.end_of_day)
      .order(:starts_at)
  }

  def self.availabilities(date)
    availabilities = AvailableService.new(date)
    availabilities.call
  end
end
