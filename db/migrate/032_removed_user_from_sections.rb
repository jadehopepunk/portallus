class RemovedUserFromSections < ActiveRecord::Migration
  def self.up
    remove_column(:sections, :user_id)
  end

  def self.down
    add_column(:sections, :user_id, :integer)
  end
end
