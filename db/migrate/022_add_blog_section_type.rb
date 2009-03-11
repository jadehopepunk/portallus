class AddBlogSectionType < ActiveRecord::Migration
  def self.up
  	content = SectionType.new
  	content.name = 'Blog'
  	content.title = 'Blog'
  	content.description = 'Create a Blog (an online journal) which displays articles you enter from newest to oldest.'
  	content.create
  end

  def self.down
  	SectionType.delete_all "name = 'Blog'"
  end
end
