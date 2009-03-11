class AddIsUserCreatableColumnToSectionTypes < ActiveRecord::Migration
  def self.up
    add_column(:section_types, :is_user_creatable, :boolean)
  end

  def self.down
    remove_column(:section_types, :is_user_creatable)
  end
end
