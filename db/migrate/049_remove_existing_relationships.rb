class RemoveExistingRelationships < ActiveRecord::Migration
  def self.up
    Relationship.delete_all
  end

  def self.down
  end
end
