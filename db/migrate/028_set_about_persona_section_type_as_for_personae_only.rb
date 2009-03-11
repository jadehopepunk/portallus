class SetAboutPersonaSectionTypeAsForPersonaeOnly < ActiveRecord::Migration
  def self.up
  	section = SectionType.find(:first, :conditions => ["name = 'AboutPersona'"])
  	section.site_type = 'Persona'
  	section.save
  end

  def self.down
  	section = SectionType.find(:first, :conditions => ["name = 'AboutPersona'"])
  	section.site_type = ''
  	section.save
  end
end
