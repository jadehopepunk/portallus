class CopyEmlynToCraigsUser < ActiveRecord::Migration
  def self.up
    emlyn_site = Site.find(13)
    emlyn_site.user_id = 1
    emlyn_site.save

    User.destroy_all('id = 75')
  end

  def self.down
  end
end
