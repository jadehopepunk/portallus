class SectionBelongsToPerson < ActiveRecord::Migration
  def self.up
    Section.find(:all).each do |section|
      if section.user_id != nil
        user = User.find(section.user_id)
        if user != nil
          section.site = Site.find(:first, :conditions => ["user_id = ?", section.user_id])
          section.save
        end
      end
    end
  end

  def self.down
  end
end
