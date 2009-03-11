class LinkRelationshipsToRelationshipDetails < ActiveRecord::Migration
  def self.up
    add_column(:relationships, :relationship_details_id, :integer)
    add_column(:relationships, :approved, :boolean)
  end

  def self.down
    remove_column(:relationships, :relationship_details_id)
    remove_column(:relationships, :approved)
  end
end
