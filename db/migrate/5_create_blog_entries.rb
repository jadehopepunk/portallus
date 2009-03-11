class CreateBlogEntries < ActiveRecord::Migration
  def self.up
      create_table :blog_entries do |table|
        table.column(:section_id,  :integer)
        table.column(:heading, :text)
        table.column(:text, :text)
        table.column(:more_text, :text)
        table.column(:created_at, :datetime)
      end
  end

  def self.down
      drop_table :blog_entries      
  end
end
