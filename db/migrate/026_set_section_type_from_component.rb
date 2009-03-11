class SetSectionTypeFromComponent < ActiveRecord::Migration
  def self.up
    execute "UPDATE sections SET section_type_id = 1 WHERE component = 'SinglePage'"
    execute "UPDATE sections SET section_type_id = 2 WHERE component = 'Blog'"
    execute "UPDATE sections SET section_type_id = 3 WHERE component = 'AboutPersona'"
  end

  def self.down
    execute "UPDATE sections SET section_type_id = 0"
  end
end
