class CreateSectionsTable < ActiveRecord::Migration
  def self.up
      create_table :sections do |table|
        table.column(:user_id,  :integer)
        table.column(:parent_section_id,  :integer)
        table.column(:component, :string, :limit => 50)
        table.column(:name, :string, :limit => 30)
        table.column(:position,  :integer)
        table.column(:heading, :text)
      end
  end

  def self.down
      drop_table :sections
  end
end
