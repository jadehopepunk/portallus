
class CreateEventSetForEveryCalendarSection < ActiveRecord::Migration
  def self.up
    calendar_type = SectionType.find(:first, :conditions => ["name = 'Calendar'"])
    calendar_sections = Section.find(:all, :conditions => ["section_type_id = ?", calendar_type.id])
    calendar_sections.each do |section|
      set = EventSet.new
      set.section = section
      set.create

      section_events = Event.find(:all, :conditions => ["section_id = ?", section.id])
      section_events.each do |event|
        event.event_set = set
        event.save
      end
    end
  end

  def self.down
    EventSet.delete_all
  end
end
