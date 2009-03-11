class CreatePersonaDetails < ActiveRecord::Migration
  def self.up
      create_table :persona_details do |table|
        table.column(:section_id, :int)
        table.column(:title, :string)
        table.column(:local_group, :string)
        table.column(:kingdom, :string)
        table.column(:historical_context, :text)
        table.column(:awards, :text)
        table.column(:offices_held, :text)
        table.column(:site_introduction, :text)
      end
  end

  def self.down
      drop_table :persona_details
  end
end
