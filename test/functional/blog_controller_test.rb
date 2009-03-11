require File.dirname(__FILE__) + '/../test_helper'
require 'components/blog/component_controller'
require 'flexmock'

# Re-raise errors caught by the controller.
class Blog::ComponentController; def rescue_action(e) raise e end; end

#class BlogControllerTest < Test::Unit::TestCase
#	def setup
#
#		FindManager.setup
#		FindManager.allow_unexpected = true
#    	@controller = Blog::ComponentController.new
#		@response   = ActionController::TestResponse.new
#		@session    = ActionController::TestSession.new
#
#		@mock_section = FlexMock.new
#		@mock_section.mock_ignore_missing
#
#		@test_entry = BlogEntry.new
#		@test_entry.id = 5
#	end
#
#	def teardown
#		FindManager.teardown
#	end
#
##	def test_show_loads_entry_specified_by_id_and_section
##		@mock_section.mock_handle(:record_id) { 23 }
##		@controller.params = {:section => @mock_section, :name => '14'}
##		FindManager.set_find_result(@test_entry, :first, :conditions => ['id = ? AND section_id = ?', '14', 23])
##
##		@controller.show
##
##		assert_equal(@test_entry, @controller.view_data["@entry"])
##	end
##
##	def test_index_loads_path
##		test_path = "some/path/string"
##		@controller.params = {:section => @mock_section, :base_path => test_path}
##
##		@controller.index
##
##		assert_equal(test_path, @controller.view_data["@path"])
##	end
##
##	def test_index_load_active_section
##		@controller.params = {:section => @mock_section}
##
##		@controller.index
##
##		assert_equal(@mock_section, @controller.view_data["@section"])
##	end
##
##	def test_index_loads_first_five_entries
##		mock_entries = [@test_entry]
##		@mock_section.mock_handle(:record_id) { 33 }
##		@controller.params = {:section => @mock_section, 'start' => '0'}
##		FindManager.set_find_result(
##			mock_entries,
##			:all,
##			:conditions => ['section_id = ?', 33],
##			:limit => 5,
##			:offset => 0,
##			:order => 'created_at DESC');
##
##		@controller.index
##
##		assert_equal(mock_entries, @controller.view_data["@entries"])
##	end
##
##	def test_index_offsets_entries_by_start_parameter
##		mock_entries = [@test_entry]
##		@mock_section.mock_handle(:record_id) { 33 }
##		@controller.params = {:section => @mock_section, 'start' => '4'}
##		FindManager.set_find_result(
##			mock_entries,
##			:all,
##			:conditions => ['section_id = ?', 33],
##			:limit => 5,
##			:offset => 4,
##			:order => 'created_at DESC');
##
##		@controller.index
##
##		assert_equal(mock_entries, @controller.view_data["@entries"])
##	end
##
##	def test_index_loads_next_five_old_entries
##		mock_entries = [@test_entry]
##		@mock_section.mock_handle(:record_id) { 33 }
##		@controller.params = {:section => @mock_section, 'start' => '0'}
##		FindManager.set_find_result(
##			mock_entries,
##			:all,
##			:conditions => ['section_id = ?', 33],
##			:limit => 5,
##			:offset => 5,
##			:order => 'created_at DESC');
##
##		@controller.index
##
##		assert_equal(mock_entries, @controller.view_data["@old_entries"])
##	end
##
##	def test_index_offsets_old_entries_by_start_parameter
##		mock_entries = [@test_entry]
##		@mock_section.mock_handle(:record_id) { 33 }
##		@controller.params = {:section => @mock_section, 'start' => '7'}
##		FindManager.set_find_result(
##			mock_entries,
##			:all,
##			:conditions => ['section_id = ?', 33],
##			:limit => 5,
##			:offset => 12,
##			:order => 'created_at DESC');
##
##		@controller.index
##
##		assert_equal(mock_entries, @controller.view_data["@old_entries"])
##	end
##
##	def test_index_loads_older_link_after_the_current_entries
##		@mock_section.mock_handle(:record_id) { 44 }
##		@controller.params = {:section => @mock_section}
##		FindManager.set_count_result(11, ['section_id = ?', 44])
##
##		@controller.index
##
##		assert_equal('start=5', @controller.view_data["@older_link"])
##	end
##
##	def test_index_loads_newer_link_if_there_are_records_before_start
##		@controller.params = {:section => @mock_section, 'start' => '7'}
##
##		@controller.index
##
##		assert_equal('start=2', @controller.view_data["@newer_link"])
##	end
##
##	def test_index_doesnt_load_newer_link_if_we_are_at_the_start
##		@controller.params = {:section => @mock_section}
##
##		@controller.index
##
##		assert_equal(nil, @controller.view_data["@newer_link"])
##	end
##
##	def test_index_adds_edit_link_to_entries
##		mock_entries = [@test_entry]
##		@controller.params = {:section => @mock_section}
##		@mock_section.mock_handle(:record_id) { 33 }
##		FindManager.set_find_result(
##			mock_entries,
##			:all,
##			:conditions => ['section_id = ?', 33],
##			:limit => 5,
##			:offset => 0,
##			:order => 'created_at DESC');
##
##		@controller.index
##
##		assert(@controller.view_data["@entries"][0] != nil)
##		assert_equal("edit/5", @controller.view_data["@entries"][0].edit_link)
##	end
##
##	def test_index_adds_show_link_to_entries
##		mock_entries = [@test_entry]
##		@controller.params = {:section => @mock_section}
##		@mock_section.mock_handle(:record_id) { 33 }
##		FindManager.set_find_result(
##			mock_entries,
##			:all,
##			:conditions => ['section_id = ?', 33],
##			:limit => 5,
##			:offset => 0,
##			:order => 'created_at DESC');
##
##		@controller.index
##
##		assert(@controller.view_data["@entries"][0] != nil)
##		assert_equal("show/5", @controller.view_data["@entries"][0].show_link)
##	end
#
## 	def test_edit_sets_edit_entry
## 		@mock_section.mock_handle(:record_id) { 33 }
## 		@mock_section.mock_handle(:to_param) { '' }
## 		@controller.params = {:section => @mock_section, :name => '15'}
## 		FindManager.set_find_result(@test_entry, :first, :conditions => ['id = ? AND section_id = ?', '15', 33])
##
## 		@controller.edit
##
## 		assert_equal(@test_entry, @controller.view_data["@edit_entry"])
## 	end
##
## 	def test_edit_sets_section
## 		@mock_section.mock_handle(:record_id) { 33 }
## 		@controller.params = {:section => @mock_section, :name => '15'}
## 		FindManager.set_find_result(@test_entry, :first, :conditions => ['id = ? AND section_id = ?', '15', 33])
##
## 		@controller.edit
##
## 		assert_equal(@mock_section, @controller.view_data["@section"])
## 	end
#
#	#def test_stuff
#		#@mock_section.mock_handle(:record_id) { 33 }
#		#@controller.params = {:section => @mock_section, :name => '15'}
#		#FindManager.set_find_result(@test_entry, :first, :conditions => ['id = ? AND section_id = ?', '15', 33])
#
#		#@request.env['REQUEST_METHOD'] = "POST"
#		#assert_equal("fish", @controller.edit)
#	#end
#
#end


