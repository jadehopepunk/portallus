class CreatePagesTable < ActiveRecord::Migration
  def self.up
      create_table :pages do |table|
        table.column(:section_id,  :integer)
        table.column(:text, :text)
      end
  end

  def self.down
      drop_table :pages
  end
end
