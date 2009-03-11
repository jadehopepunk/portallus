class SetPortallusLastName < ActiveRecord::Migration
  def self.up
    user = User.find(41)
    user.last_name = ':'
    user.update
  end

  def self.down
    user = User.find(41)
    user.last_name = ''
    user.update
  end
end
