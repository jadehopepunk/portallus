class MakeSomeSectionsUserCreatable < ActiveRecord::Migration
  def self.up
    execute("UPDATE section_types SET is_user_creatable = 1 WHERE name != 'sitelist'")
  end

  def self.down
    execute("UPDATE section_types SET is_user_creatable = 0")
  end
end
