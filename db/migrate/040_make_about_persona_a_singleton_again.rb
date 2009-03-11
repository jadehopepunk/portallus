class MakeAboutPersonaASingletonAgain < ActiveRecord::Migration
  def self.up
    section_type = SectionType.find(:first, :conditions => ["name = 'AboutPersona'"])
    section_type.is_singleton = true
    section_type.save
  end

  def self.down
    section_type = SectionType.find(:first, :conditions => ["name = 'AboutPersona'"])
    section_type.is_singleton = false
    section_type.save
  end
end
