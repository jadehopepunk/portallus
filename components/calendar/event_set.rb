class EventSet < ActiveRecord::Base
  belongs_to :section
  has_many :events
  validates_presence_of :section

  def all_events_between_dates(start_date, end_date)
    start_time = Time.mktime(start_date.year, start_date.mon, start_date.mday, 0, 0, 0, 0)
    after_end_date = end_date + 1
    end_time = Time.mktime(after_end_date.year, after_end_date.mon, after_end_date.mday, 0, 0, 0, 0)

    self.all_events_between_times(start_time, end_time)
  end

  def all_events_between_times(start_time, end_time)
    Event.find(
        :all,
        :conditions => ["event_set_id = ? and ((start >= ? and start <= ?) or (end >= ? and end <= ?) or (start < ? and end > ?))", id, start_time, end_time, start_time, end_time, start_time, end_time],
        :order => "start ASC",
        :readonly => true
      )
  end

  def find_event(event_id)
    Event.find(:first, :conditions => ["id = ? and event_set_id = ?", event_id, id])
  end


end
