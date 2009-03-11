class RemovePictureFromPersonaDetails < ActiveRecord::Migration
  def self.up
    remove_column(:persona_details, :picture)
  end

  def self.down
    add_column(:persona_details, :picture, :string)
  end
end
