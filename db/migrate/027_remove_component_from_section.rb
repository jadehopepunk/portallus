class RemoveComponentFromSection < ActiveRecord::Migration
  def self.up
  	remove_column(:sections, :component)
  end

  def self.down
  	add_column(:sections, :component, :text)
  	Section.find_all.each do |section|
  		if section.section_type_id == 1 then section.component = 'SinglePage' end
  		if section.section_type_id == 2 then section.component = 'Blog' end
  		if section.section_type_id == 3 then section.component = 'AboutPersona' end
  		section.save
  	end  	
  end
end
