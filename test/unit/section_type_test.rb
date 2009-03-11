require File.dirname(__FILE__) + '/../test_helper'

class SectionTypeTest < Test::Unit::TestCase
  fixtures :section_types

  def test_can_be_used_on_is_false_if_site_is_nil
    section_type = SectionType.new
    assert_equal(false, section_type.can_be_used_on?(nil))
  end

  def test_can_be_used_on_is_false_if_site_type_is_blank
    site = Site.new

    section_type = SectionType.new
    assert_equal(false, section_type.can_be_used_on?(site))
  end

  def test_can_be_used_on_is_true_if_site_type_is_not_blank
    site = Person.new

    section_type = SectionType.new
    section_type.site_type = ''
    assert_equal(true, section_type.can_be_used_on?(site))
  end

  def test_can_be_used_on_is_false_if_site_type_doesnt_match_specified_type
    site = Person.new

    section_type = SectionType.new
    section_type.site_type = 'NotPerson'
    assert_equal(false, section_type.can_be_used_on?(site))
  end

  def test_another_instance_allowed_true_if_site_type_is_singleton_but_isnt_used_yet
    site = Person.new

    section_type = SectionType.new
    section_type.site_type = ''
    section_type.is_singleton = true
    assert_equal(true, section_type.another_instance_allowed(site))
  end

  def test_another_instance_allowed_false_if_site_type_is_singleton_and_is_already_used_on_site
    site = Person.new

    section_type = SectionType.new
    section_type.site_type = ''
    section_type.is_singleton = true

    existing_section = Section.new
    existing_section.section_type = section_type
    site.sections << existing_section

    assert_equal(false, section_type.another_instance_allowed(site))
  end

end
