class MakeAllCurrentSitesPeople < ActiveRecord::Migration
  def self.up
	execute "UPDATE sites SET type='Person'"
  end

  def self.down
	execute "UPDATE sites SET type=''"
  end
end
