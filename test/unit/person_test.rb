require File.dirname(__FILE__) + '/../test_helper'

class PersonTest < Test::Unit::TestCase
	fixtures :sites, :sections

	def setup
	end

	def test_update_unique_name_sets_unique_name_to_first_name
		person = Person.new
		person.first_name = "newname"
		person.update_unique_name
		assert_equal("newname", person.unique_name)
	end

	def test_update_unique_name_sets_unique_name_to_first_name_plus_last_name
		person = Person.new
		person.first_name = "bilbo"
		person.last_name = "baggins"
		person.update_unique_name
		assert_equal("bilbobaggins", person.unique_name)
	end

	def test_update_unique_name_sets_unique_name_to_lower_case
		person = Person.new
		person.first_name = "BilbO"
		person.last_name = "Baggins"
		person.update_unique_name
		assert_equal("bilbobaggins", person.unique_name)
	end

	def test_update_unique_name_strips_non_alpha_characters
		person = Person.new
		person.first_name = "bil_bo"
		person.last_name = "bag'gins"
		person.update_unique_name
		assert_equal("bilbobaggins", person.unique_name)
	end

	def test_update_unique_name_ads_number_if_name_already_exists
		person = Person.new
		person.first_name = "bob"
		person.update_unique_name
		assert_equal("bob1", person.unique_name)
	end

	def test_update_unique_name_increments_number_if_name_and_number_already_exists
		person = Person.new
		person.first_name = "frank"
		person.update_unique_name
		assert_equal("frank3", person.unique_name)
	end

	def test_name_returns_first_name_plus_last_name
		person = Person.new
		person.first_name = 'bilbo'
		person.last_name = 'baggins'
		assert_equal('bilbo baggins', person.name)
	end

	def test_name_returns_just_first_name_if_no_last_name
		person = Person.new
		person.first_name = 'bilbo'
		assert_equal('bilbo', person.name)
	end

	def test_root_section_returns_root_section_for_this_person
		person = Person.find(4)
		assert_equal(Section.find(2), person.root_section.children[0])
	end

	def test_find_first_section_returns_nil_if_no_sections_for_that_person
		person = Person.find(1)
		assert_equal(nil, person.find_first_section(['lastsection']))
	end

	def test_find_first_section_returns_section_with_matching_name_and_person
		person = Person.find(4)
		assert_equal(Section.find(1), person.find_first_section(['lastsection']))
	end

	def test_find_first_section_returns_child_section_with_matching_name_and_person
		person = Person.find(4)
		assert_equal('child2', person.find_first_section(['lastsection', 'child2']).name)
	end

	def test_find_first_section_works_if_only_the_first_part_of_name_matches_section
		person = Person.find(5)
		result = person.find_first_section(['mystuff', 'edit'])
		assert_not_nil(result)
		assert_equal('mystuff', result.name) unless result == nil
	end

	def test_to_param_returns_login_name
		person = Person.new
		person.unique_name = 'bilbobaggins'
		assert_equal('bilbobaggins', person.to_param)
	end


end
