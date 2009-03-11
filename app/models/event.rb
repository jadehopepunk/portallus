class Event < ActiveRecord::Base
  belongs_to :section
  validates_presence_of :title, :start, :section

  def validate
    errors.add(:end, "must be later than start time.") if self.end < self.start
  end

  def start_date
    date_from_datetime(start)
  end

  def end_date
    date_from_datetime(self.end)
  end

  def all_dates
    start_date..end_date
  end

  def start_time
    time_from_datetime(start)
  end

  def end_time
    time_from_datetime(self.end)
  end

  def all_dates_between(start_date, end_date)
    result = Array.new

    all_dates.each do |date|
      result << date if date >= start_date and date <= end_date
    end
    result
  end



private

  def time_from_datetime(datetime)
    Time.gm(0, 1, 1, datetime.hour, datetime.min, datetime.sec)
  end

  def date_from_datetime(datetime)
    Date.new(datetime.year, datetime.mon, datetime.mday)
  end

end
