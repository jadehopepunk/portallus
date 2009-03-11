class AllocatePortallusToCraig < ActiveRecord::Migration
  def self.up
    site = Site.find(:first, :conditions => ["unique_name = 'portallus'"])
    site.user_id = 1
    site.save
  end

  def self.down
    site = Site.find(:first, :conditions => ["unique_name = 'portallus'"])
    site.user_id = 41
    site.save
  end
end
