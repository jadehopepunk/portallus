class AddPersonaListSectionType < ActiveRecord::Migration
  def self.up
    persona_list = SectionType.new
    persona_list.name = 'PersonaList'
    persona_list.title = 'Persona List'
    persona_list.site_type = 'Domain'
    persona_list.is_user_creatable = true
    persona_list.create
  end

  def self.down
    persona_list.find(:first, :condition => ["name = 'PersonaList"]).destroy
  end
end
