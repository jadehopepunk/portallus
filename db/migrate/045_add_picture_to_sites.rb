class AddPictureToSites < ActiveRecord::Migration
  def self.up
    add_column(:sites, :picture, :string)
  end

  def self.down
    remove_column(:sites, :picture)
  end
end
