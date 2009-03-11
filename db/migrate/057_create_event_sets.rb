class CreateEventSets < ActiveRecord::Migration
  def self.up
      create_table :event_sets do |table|
        table.column(:section_id, :integer)
      end  end

  def self.down
      drop_table :event_sets
  end
end
