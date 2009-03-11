class MakeEmlynAPersona < ActiveRecord::Migration
  def self.up
    execute("UPDATE sites SET type = 'Persona', society_name = 'Emlyn ap Rhys', first_name = '', last_name = '', title = '' WHERE id = 13")
  end

  def self.down
    execute("UPDATE sites SET type = 'Person', society_name = '', first_name = 'Emlyn', last_name = 'ap Rhys', title = '' WHERE id = 13")
  end
end
