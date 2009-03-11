class AddCalendarSectionType < ActiveRecord::Migration
  def self.up
    section_type = SectionType.new
    section_type.name = 'Calendar'
    section_type.title = 'Calendar'
    section_type.description = 'Manage your upcoming events and share them with friends.'
    section_type.is_user_creatable = true
    section_type.create
  end

  def self.down
    SectionType.find(:first, :conditions => ["name = 'Calendar'"]).destroy
  end
end
