class AddIsHierarchicalColumnToSectionType < ActiveRecord::Migration
  def self.up
    add_column(:section_types, :is_hierarchical, :boolean)
  end

  def self.down
    remove_column(:section_types, :is_hierarchical)
  end
end
