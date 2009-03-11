class AddContentSectionType < ActiveRecord::Migration
  def self.up
  	content = SectionType.new
  	content.name = 'SinglePage'
  	content.title = 'Single Page'
  	content.description = 'A website page which can be edited, and have other sub pages.'
  	content.create
  end

  def self.down
  	content.Delete
  	SectionType.delete_all "name = 'SinglePage'"
  end
end
