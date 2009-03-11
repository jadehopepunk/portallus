class CreateRelationshipModel < ActiveRecord::Migration
  def self.up
      create_table :relationships do |table|
        table.column(:source_id,  :integer)
        table.column(:destination_id, :integer)
        table.column(:description, :string)
      end
  end

  def self.down
      drop_table :relationships
  end
end
