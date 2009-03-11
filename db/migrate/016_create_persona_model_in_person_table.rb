class CreatePersonaModelInPersonTable < ActiveRecord::Migration
  def self.up
  	add_column(:sites, :type, :string)
  	add_column(:sites, :society_name, :text)
  end

  def self.down
  	remove_column(:sites, :type)
  	remove_column(:sites, society_name)
  end
end
