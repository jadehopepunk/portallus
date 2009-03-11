class AddSectionTypeToSection < ActiveRecord::Migration
  def self.up
  	add_column(:sections, :section_type_id, :integer)
  end

  def self.down
  	remove_column(:sections, :section_type_id)
  end
end
