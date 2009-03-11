class SetSiteListSectionType < ActiveRecord::Migration
  def self.up
    execute ("UPDATE sections SET section_type_id = '4' WHERE name = 'sitelist' and site_id = 5")
  end

  def self.down
    execute ("UPDATE sections SET section_type_id = '0' WHERE name = 'sitelist' and site_id = 5")
  end
end
