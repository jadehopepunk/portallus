class IncreasePageTextSize < ActiveRecord::Migration
  def self.up
    execute "ALTER TABLE pages CHANGE text text MEDIUMTEXT"
  end

  def self.down
    execute "ALTER TABLE pages CHANGE text text TEXT"
  end
end
