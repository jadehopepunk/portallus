require 'user.rb'
require 'person.rb'

class CreatePeopleForUsers < ActiveRecord::Migration
  def self.up
    User.find(:all).each do |user|
      site = Site.new
      site.user_id = user.id
      site.unique_name = user.login
      site.first_name = user.first_name
      site.last_name = user.last_name
      site.title = user.title
      unless site.save
        raise "Site save failed for " + user.login + ": " + site.errors.full_messages.inspect
      end
    end
  end

  def self.down
    Sites.delete_all
  end
end
