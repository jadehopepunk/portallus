class CreateEventTable < ActiveRecord::Migration
  def self.up
      create_table :events do |table|
        table.column(:title,  :string)
        table.column(:location, :text)
        table.column(:details, :text)
        table.column(:start, :datetime)
        table.column(:end, :datetime)
        table.column(:section_id, :integer)
      end
  end

  def self.down
      drop_table :events
  end
end
