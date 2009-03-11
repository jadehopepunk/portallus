require File.dirname(__FILE__) + '/../database_test_helper'
require 'section'
require 'single_page/page.rb'

class SectionTest < Test::Unit::TestCase
	fixtures :sections, :pages, :section_types

	def test_save_and_reload
		section = Section.new
		section.heading = 'New Section'
		section.name = 'bobthebuilder'
		section.position = 23
		section.id = 50
		section.site = Person.new
		section.section_type_id = SectionType.find(1)
		
		section.save
		section.reload
		
		assert_equal('New Section', section.heading)		
	end
  
	def test_saving_section_gives_it_a_unique_name
		section = Section.new
		section.heading = 'I Like Fish'
		section.save 
		
		assert_equal('ilikefish', section.name)
	end

	def test_names_over_thirty_characters_are_truncated
		section = Section.new
		section.heading = 'I really like lots of tasty Fish goodness'
		section.save 
		
		assert_equal('ireallylikelotsoftastyfishgood', section.name)
	end

	def test_names_are_always_unique  	
		section = Section.new
		section.heading = 'Last Section'
		section.site_id = 4
		section.save 
  	
		assert_equal('lastsection2', section.name)  
	end

	def test_parent_section_is_loaded
		section = Section.find(3)
		assert_equal(1, section.parent.id)
	end
	
	def test_parent_section_is_new_object_if_no_id_specified
		section = Section.new
		assert_equal(nil, section.parent.id)
		assert(section.parent.new_record?)
	end

	def test_parent_section_has_child
		section = Section.find(3)
		assert_equal(3, section.parent.children[0].id)
	end

	def test_name_suffix_is_incremented_if_exists
		section = Section.new
		section.heading = 'Child'
		section.parent_section_id = 1
		section.save 
		
		assert_equal('child3', section.name)
	end
  
	def test_section_cannot_be_called_new
		section = Section.new
		section.heading = 'New'
		section.save
  	
		assert_equal('new2', section.name)
	end
  
	def test_add_child_puts_child_in_correct_position
		child_section = Section.new
		child_section.heading = 'Child'

		parent = Section.find(1)  
		parent.add_child(child_section)
		child_section.save
		  	
		parent.reload
		assert_equal(3, parent.children.length)
		assert_equal(child_section.id, parent.children[2].id)
	end
	
	def test_has_children
		assert_equal(true, Section.find(1).has_children)
		assert_equal(false, Section.find(2).has_children)
	end
  
	def test_hierarchy_name
		section = Section.find(1)
		assert_equal('lastsection', section.hierarchy_name)
		  	
		section = Section.find(3)
		assert_equal('lastsection/child', section.hierarchy_name)
	end
  
	def test_move_forward_on_unit_collection_does_nothing		
		child = Section.find(5)

		child.move_forward
	
		assert_equal(child.id, child.parent.children[0].id)
		assert_equal(1, child.position)
	end

	def test_move_backward_on_unit_collection_does_nothing
		child = Section.find(5)

		child.move_backward
	
		assert_equal(child.id, child.parent.children[0].id)
		assert_equal(1, child.position)
	end
  
	def test_move_forward_on_tail_item_of_collection_does_nothing
		child = Section.find(4)
		
		child.move_forward
	
		assert_equal(child.id, child.parent.children[1].id)
		assert_equal(2, child.position)
	end

	def test_move_backward_on_head_item_of_collection_does_nothing
		child = Section.find(3)
		
		child.move_backward
	
		assert_equal(child.id, child.parent.children[0].id)
		assert_equal(1, child.position)
	end
	
	def test_children_of_new_section_are_root_sections_only
		section = Section.new_root
		section.site_id = 4
		assert_equal(2, section.children.length)
	end
	
	def test_new_section_gets_next_available_position
		new_section = Section.new
		new_section.heading = 'Test New Section'
		new_section.site_id = 4
		
		new_section.save
		
		assert_equal(3, new_section.position)
	end

	def test_find_with_name_array_returns_nill_on_empty_array
		assert_equal(nil, Section.find_with_name_array([]))
	end
	
	def test_parent_section_sets_parent_section_id
		section = Section.find(2)
		section.parent = Section.find(1)
		section.section_type = SectionType.find(1)
		section.save
		assert_equal(1, Section.find(2).parent_section_id)
	end
	
	def test_name_array_returns_correct_hierarchy
		assert_equal(['lastsection', 'child2'], Section.find(4).name_array)
	end
	
	def test_to_param
		assert_equal('lastsection/child2', Section.find(4).to_param)
	end
	
	def test_root_parent_doesnt_have_parent
		root_parent = Section.find(1).parent
		assert_equal(nil, root_parent.parent)
	end
	
	def test_new_root_section_is_root
		assert_equal(true, Section.new_root.is_root?)
	end
	
	def test_section_with_parent_section_id_is_not_root
		section = Section.new
		section.parent_section_id = 1
		assert_equal(false, section.is_root?)
	end
	
	def test_breadcrumb_trail
		assert_equal([Section.find(1), Section.find(4)], Section.find(4).breadcrumb_trail)		
	end

	def test_set_site_sets_site_id
		person = Person.new
		person.id = 23
	
		section = Section.new
		section.site = person
		section.heading = 'New'
		section.position = 1
		section.section_type_id = SectionType.find(1)
				
		section.save
		
		assert_equal(23, section.site_id)
	end
	
	def test_parent_section_has_same_site_id_as_child
		section = Section.new
		section.heading = 'Last Section'
		section.site_id = 4
		section.section_type_id = SectionType.find(1)
		section.save
		
		assert_equal(4, section.parent.site_id)
	end

	def test_deleting_section_deletes_all_pages
		section = Section.find(1)
		assert_equal(2, Page.find(:all, 'section_id = ?', 1).length)
		section.destroy
		assert_equal(0, Page.find(:all, 'section_id = ?', 1).length)
	end
	
	def test_trim_name_heirarchy_from_array_does_nothing_if_array_doesnt_match
		section = Section.find(5)
		assert_equal(['fish'], section.trim_name_heirarchy_from_array(['fish']))	
	end
	
	def test_trim_name_heiriarchy_trims_one_name
		section = Section.find(2)
		assert_equal([], section.trim_name_heirarchy_from_array(['firstsection']))	
	end
	
	def test_trim_name_heirarchy_trims_multiple_names
		section = Section.find(5)
		assert_equal(['notneeded'], section.trim_name_heirarchy_from_array(['lastsection', 'child2', 'onlychild', 'notneeded']))	
	end
	
	def test_destroying_section_destroys_its_children
		assert_equal(true, Section.exists?(1))

		section = Section.find(1)
		section.destroy

		assert_equal(false, Section.exists?(1))
		assert_equal(false, Section.exists?(3))
	end
	
end
