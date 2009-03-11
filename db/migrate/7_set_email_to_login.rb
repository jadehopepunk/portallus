class SetEmailToLogin < ActiveRecord::Migration
  def self.up
  	User.find(:all).each do |user|
  		user.email = user.login
  		user.save
  	end
  end

  def self.down
  	User.find(:all).each do |user|
  		user.email = ''
  		user.save
  	end
  end
end
