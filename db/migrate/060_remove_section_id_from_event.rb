class RemoveSectionIdFromEvent < ActiveRecord::Migration
  def self.up
    remove_column(:events, :section_id)
  end

  def self.down
  end
end
