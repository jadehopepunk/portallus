require 'person.rb'

class CreatePersonTable < ActiveRecord::Migration
  def self.up
      create_table :sites do |table|
        table.column(:user_id, :integer)
        table.column(:unique_name, :string, :limit => 80)
        table.column(:first_name, :string)
        table.column(:last_name, :string)
        table.column(:title, :text)
      end
  end

  def self.down
      drop_table :sites
  end
end
