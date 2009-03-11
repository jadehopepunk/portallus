class ChangeImagePersonColumnToSite < ActiveRecord::Migration
  def self.up
    rename_column(:images, :person_id, :site_id)
  end

  def self.down
    rename_column(:images, :site_id, :person_id)
  end
end
