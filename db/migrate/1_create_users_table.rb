class CreateUsersTable < ActiveRecord::Migration
  def self.up
      create_table :users do |table|
        table.column(:login,  :string, :limit => 80)
        table.column(:password, :string, :limit => 40)
        table.column(:first_name, :text)
        table.column(:last_name, :text)
        table.column(:title, :text)
      end
    end

  def self.down
      drop_table :users
  end
end
