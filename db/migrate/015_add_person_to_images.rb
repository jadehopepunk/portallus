class AddPersonToImages < ActiveRecord::Migration
  def self.up
  	add_column(:images, :person_id, :integer)
  end

  def self.down
  	remove_column(:images, :person_id)
  end
end
