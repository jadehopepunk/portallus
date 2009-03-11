
class Relationship < ActiveRecord::Base
  belongs_to(:source, :class_name => 'Site', :foreign_key => 'source_id')
  belongs_to(:destination, :class_name => 'Site', :foreign_key => 'destination_id')
  belongs_to(:relationship_details, :class_name => 'RelationshipDetails', :foreign_key => 'relationship_details_id')
  validates_presence_of :source_id, :destination_id, :description

  def available_destinations
    conditions = ['id != ?', source.id] unless source == nil
    Persona.find(:all, :conditions => conditions, :order => "society_name ASC")
  end

protected

  def before_validation
    self.description = self.description.strip unless self.description == nil
  end

  def validate
    unless self.class.find(:first, :conditions => ["source_id = ? and description = ? and destination_id = ?", source_id, description, destination_id]) == nil
      errors.add_to_base("This relationship already exists.")
    end
  end

end
