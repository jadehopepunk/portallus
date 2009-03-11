class AddSingletonColumnToSectionTypes < ActiveRecord::Migration
  def self.up
  	add_column(:section_types, :is_singleton, :boolean)
  end

  def self.down
  	remove_column(:section_types, :is_singleton)
  end
end
