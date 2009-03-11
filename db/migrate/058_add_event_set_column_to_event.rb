class AddEventSetColumnToEvent < ActiveRecord::Migration
  def self.up
    add_column(:events, :event_set_id, :integer)
  end

  def self.down
    remove_column(:events, :event_set_id)
  end
end
