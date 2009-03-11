class AddRelationshipsSectionType < ActiveRecord::Migration
  def self.up
    relationships = SectionType.new
    relationships.name = "Relationships"
    relationships.title = "Relationships"
    relationships.description = "Relationships with other sites"
    relationships.site_type = "Persona"
    relationships.is_singleton = true
    relationships.is_user_creatable = false
    relationships.create
  end

  def self.down
    relationships = SectionType.find(:first, :conditions => ['name = ?', 'Relationships'])
    relationships.destroy
  end
end
