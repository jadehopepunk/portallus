require File.dirname(__FILE__) + '/../database_test_helper'
require 'section_controller'

# Re-raise errors caught by the controller.
class SectionController; def rescue_action(e) raise e end; end

class SectionControllerTest < Test::Unit::TestCase
	fixtures :sections, :users

	def setup
		@controller = SectionController.new
		@request = ActionController::TestRequest.new
		@response = ActionController::TestResponse.new
	end

	def test_show
		get :show, 'name' => ['firstsection'], 'username' => 'bob'
		assert_rendered_file 'show'
		assert(assigns['section_content'] != nil)
		assert_response :success
	end

	def test_show_without_name_shows_first_section
		get :show, 'username' => 'bob'
		assert_rendered_file 'show'
		assert_template_has 'section'
		assert(assigns['section_content'] != nil)
		assert_response :success
	end

#	def test_new
#		get :new, 'username' => 'bob'
#		assert_rendered_file 'new'
#		assert_template_has 'section'
#	end

#	def test_new_saves_section
#		num_sections = Section.find_all.size
#
#		post(:new, :edit_section => {'heading' => 'new section', 'text' => 'some text'}, 'username' => 'bob')
#
#		assert_equal num_sections + 1, Section.find_all.size
#	end
	
#	def new_redirects_to_new_section
#		num_sections = Section.find_all.size
#
#		post(:new, :edit_section => {'heading' => 'new section'})
#		assert_redirected_to(:action => 'show', :name => 'newsection')
#	end

	#def test_edit
		#get :edit, 'name' => ['firstsection'], 'username' => 'bob'
		#assert_rendered_file 'edit'
		#assert_template_has 'section'
		#assert_valid_record 'section'
	#end

#	def test_delete
#		assert_not_nil Section.find(:first, :conditions => [ "name = ?", 'lastsection'])
#
#		post :delete, 'name' => ['lastsection'], 'username' => 'bob'
#		assert_redirected_to :action => 'show'
#
#		assert_equal(nil, Section.find(:first, :conditions => [ "name = ?", 'lastsection']))
#	end
		
end
