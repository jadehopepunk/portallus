class AddAboutPersonaSection < ActiveRecord::Migration
  def self.up
  	content = SectionType.new
  	content.name = 'AboutPersona'
  	content.title = 'About Me'
  	content.description = 'Describe your SCA Persona.'
  	content.create
  end

  def self.down
  	SectionType.delete_all "name = 'AboutPersona'"
  end
end
