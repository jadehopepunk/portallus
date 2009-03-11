class CreateBlogDetailsTable < ActiveRecord::Migration
  def self.up
      create_table :blog_details do |table|
        table.column(:section_id,  :integer)
        table.column(:text, :text)
      end
  end

  def self.down
      drop_table :blog_details
  end
end
