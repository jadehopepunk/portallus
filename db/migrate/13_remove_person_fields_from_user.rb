class RemovePersonFieldsFromUser < ActiveRecord::Migration
  def self.up
  	remove_column(:users, :first_name)
  	remove_column(:users, :last_name)
  	remove_column(:users, :title)
  	remove_column(:users, :login)
  end

  def self.down
  	add_column(:users, :first_name, :text)
  	add_column(:users, :last_name, :text)
  	add_column(:users, :title, :text)
  	add_column(:users, :login, :string)
  end
end
