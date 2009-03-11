class AddRelationshipsSectionToExistingPersonae < ActiveRecord::Migration
  def self.up
    relationships_type = SectionType.find(:first, :conditions => ['name = ?', 'Relationships'])

    Persona.find(:all).each do |persona|
      relationships = Section.new
      relationships.section_type = relationships_type
      relationships.name = 'relationships'
      relationships.heading = 'Relationships'

      persona.add_section(relationships)
      relationships.create
    end
  end

  def self.down
    Section.destroy_all('section_type_id = 5')
  end
end
