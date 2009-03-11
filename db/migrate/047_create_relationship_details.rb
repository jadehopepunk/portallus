class CreateRelationshipDetails < ActiveRecord::Migration
  def self.up
      create_table :relationship_details do |table|
      end
  end

  def self.down
      drop_table :relationship_details
  end
end
