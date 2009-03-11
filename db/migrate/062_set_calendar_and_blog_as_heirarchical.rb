class SetCalendarAndBlogAsHeirarchical < ActiveRecord::Migration
  def self.up
    hierarchical_types = SectionType.find(:all, :conditions => ["name = ? or name = ?", 'Blog', 'Calendar'])
    hierarchical_types.each do |section_type|
      section_type.is_hierarchical = true
      section_type.save
    end
  end

  def self.down
    hierarchical_types = SectionType.find(:all, :conditions => ["name = ? or name = ?", 'Blog', 'Calendar'])
    hierarchical_types.each do |section_type|
      section_type.is_hierarchical = false
      section_type.save
    end
  end
end
