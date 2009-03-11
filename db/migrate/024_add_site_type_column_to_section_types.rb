class AddSiteTypeColumnToSectionTypes < ActiveRecord::Migration
  def self.up
  	add_column(:section_types, :site_type, :text)
  end

  def self.down
  	remove_column(:section_types, :site_type)
  end
end
