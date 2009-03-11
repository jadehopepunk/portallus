class CreateScaSite < ActiveRecord::Migration
  def self.up
    sca = Domain.new
    sca.user_id = 1
    sca.unique_name = "sca"
    sca.create
  end

  def self.down
    Domain.find(:first, :conditions => ["unique_name = 'sca'"]).destroy
  end
end
