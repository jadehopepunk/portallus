class AddSiteListSectionType < ActiveRecord::Migration
  def self.up
    sitelist = SectionType.new
    sitelist.name = 'SiteList'
    sitelist.title = 'Site List'
    sitelist.create
  end

  def self.down
    sitelist = SectionType.find(:first, :conditions => ['name = ?', 'SiteList'])
    sitelist.destroy
  end
end
