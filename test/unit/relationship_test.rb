require File.dirname(__FILE__) + '/../test_helper'

class RelationshipTest < Test::Unit::TestCase
  fixtures :relationships

  # Replace this with your real tests.
  def test_truth
    assert_kind_of Relationship, relationships(:first)
  end
end
