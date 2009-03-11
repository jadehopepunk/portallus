class CreateSectionTypesTable < ActiveRecord::Migration
  def self.up
      create_table :section_types do |table|
        table.column(:name, :string, :limit => 80)
        table.column(:title, :text)
        table.column(:description, :text)
      end
  end

  def self.down
      drop_table :section_types
  end
end
