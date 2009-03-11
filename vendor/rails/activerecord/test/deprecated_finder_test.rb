require 'abstract_unit'
require 'fixtures/company'
require 'fixtures/topic'
require 'fixtures/entrant'
require 'fixtures/developer'

class DeprecatedFinderTest < Test::Unit::TestCase
  fixtures :companies, :topics, :entrants, :developers

  def test_find_all_with_limit
    entrants = Entrant.find_all nil, "id ASC", 2
    
    assert_equal(2, entrants.size)
    assert_equal(entrants(:first).name, entrants.first.name)
  end

  def test_find_all_with_prepared_limit_and_offset
    entrants = Entrant.find_all nil, "id ASC", [2, 1]

    assert_equal(2, entrants.size)
    assert_equal(entrants(:second).name, entrants.first.name)
  end

  def test_find_first
    first = Topic.find_first "title = 'The First Topic'"
    assert_equal(topics(:first).title, first.title)
  end
  
  def test_find_first_failing
    first = Topic.find_first "title = 'The First Topic!'"
    assert_nil(first)
  end
  
  def test_deprecated_find_on_conditions
    assert Topic.find_on_conditions(1, ["approved = ?", false])
    assert_raises(ActiveRecord::RecordNotFound) { Topic.find_on_conditions(1, ["approved = ?", true]) }
  end
  
  def test_condition_interpolation
    assert_kind_of Firm, Company.find_first(["name = '%s'", "37signals"])
    assert_nil Company.find_first(["name = '%s'", "37signals!"])
    assert_nil Company.find_first(["name = '%s'", "37signals!' OR 1=1"])
    assert_kind_of Time, Topic.find_first(["id = %d", 1]).written_on
  end

  def test_bind_variables
    assert_kind_of Firm, Company.find_first(["name = ?", "37signals"])
    assert_nil Company.find_first(["name = ?", "37signals!"])
    assert_nil Company.find_first(["name = ?", "37signals!' OR 1=1"])
    assert_kind_of Time, Topic.find_first(["id = ?", 1]).written_on
    assert_raises(ActiveRecord::PreparedStatementInvalid) {
      Company.find_first(["id=? AND name = ?", 2])
    }
    assert_raises(ActiveRecord::PreparedStatementInvalid) {
	   Company.find_first(["id=?", 2, 3, 4])
    }
  end
  
  def test_bind_variables_with_quotes
    Company.create("name" => "37signals' go'es agains")
    assert Company.find_first(["name = ?", "37signals' go'es agains"])
  end

  def test_named_bind_variables_with_quotes
    Company.create("name" => "37signals' go'es agains")
    assert Company.find_first(["name = :name", {:name => "37signals' go'es agains"}])
  end

  def test_named_bind_variables
    assert_equal '1', bind(':a', :a => 1) # ' ruby-mode
    assert_equal '1 1', bind(':a :a', :a => 1)  # ' ruby-mode
  
    assert_kind_of Firm, Company.find_first(["name = :name", { :name => "37signals" }])
    assert_nil Company.find_first(["name = :name", { :name => "37signals!" }])
    assert_nil Company.find_first(["name = :name", { :name => "37signals!' OR 1=1" }])
    assert_kind_of Time, Topic.find_first(["id = :id", { :id => 1 }]).written_on
    assert_raises(ActiveRecord::PreparedStatementInvalid) {
      Company.find_first(["id=:id and name=:name", { :id=>3 }])
    }
    assert_raises(ActiveRecord::PreparedStatementInvalid) {
      Company.find_first(["id=:id", { :id=>3, :name=>"37signals!" }])
    }
  end

  def test_count
    assert_equal(0, Entrant.count("id > 3"))
    assert_equal(1, Entrant.count(["id > ?", 2]))
    assert_equal(2, Entrant.count(["id > ?", 1]))
  end

  def test_count_by_sql
    assert_equal(0, Entrant.count_by_sql("SELECT COUNT(*) FROM entrants WHERE id > 3"))
    assert_equal(1, Entrant.count_by_sql(["SELECT COUNT(*) FROM entrants WHERE id > ?", 2]))
    assert_equal(2, Entrant.count_by_sql(["SELECT COUNT(*) FROM entrants WHERE id > ?", 1]))
  end

  def test_find_all_with_limit
    first_five_developers = Developer.find_all nil, 'id ASC', 5
    assert_equal 5, first_five_developers.length
    assert_equal 'David', first_five_developers.first.name
    assert_equal 'fixture_5', first_five_developers.last.name
    
    no_developers = Developer.find_all nil, 'id ASC', 0
    assert_equal 0, no_developers.length
    
    assert_equal first_five_developers, Developer.find_all(nil, 'id ASC', [5])
    assert_equal no_developers, Developer.find_all(nil, 'id ASC', [0])
  end

  def test_find_all_with_limit_and_offset
    first_three_developers = Developer.find_all nil, 'id ASC', [3, 0]
    second_three_developers = Developer.find_all nil, 'id ASC', [3, 3]
    last_two_developers = Developer.find_all nil, 'id ASC', [2, 8]
    
    assert_equal 3, first_three_developers.length
    assert_equal 3, second_three_developers.length
    assert_equal 2, last_two_developers.length
    
    assert_equal 'David', first_three_developers.first.name
    assert_equal 'fixture_4', second_three_developers.first.name
    assert_equal 'fixture_9', last_two_developers.first.name
  end

  def test_find_all_by_one_attribute_with_options
    topics = Topic.find_all_by_content("Have a nice day", "id DESC")
    assert topics(:first), topics.last

    topics = Topic.find_all_by_content("Have a nice day", "id DESC")
    assert topics(:first), topics.first
  end

  protected
    def bind(statement, *vars)
      if vars.first.is_a?(Hash)
        ActiveRecord::Base.send(:replace_named_bind_variables, statement, vars.first)
      else
        ActiveRecord::Base.send(:replace_bind_variables, statement, vars)
      end
    end
end
