class AddPictureColumnToPersonaDetails < ActiveRecord::Migration
  def self.up
    add_column(:persona_details, :picture, :string)
    add_column(:persona_details, :device, :string)
  end

  def self.down
    remove_column(:persona_details, :picture)
    remove_column(:persona_details, :device)
  end
end
