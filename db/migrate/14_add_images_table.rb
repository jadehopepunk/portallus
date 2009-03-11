class AddImagesTable < ActiveRecord::Migration
  def self.up
      create_table :images do |table|
        table.column(:file, :text)
      end
  end

  def self.down
      drop_table :images
  end
end
