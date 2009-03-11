# call this controller from your selenium tests to set up test data
# using the 'open' command, the second column should contain the url
# eg. "open /testdata" for the default fixture
# eg. "open /testdata/clean" for a clean database
# eg. "open /testdata/specialfixture" for some specially tweaked fixture

# only load in development and test environment
if ['test'].include?(RAILS_ENV) then

  require 'active_record/fixtures'

  class TestdataController < ActionController::Base
  public

    cattr_accessor :fixtures

    def self.fixtures(*table_names)
      @@fixtures = Fixtures.create_fixtures(File.dirname(__FILE__) + "/../../test/fixtures", table_names)
    end

    # add fixtures that you need for test data
    fixtures :users, :sites, :sections, :section_types

    def index
  	  reset_session

      # default test data, the fixtures as above
      render_text "Default test data setup"
    end

    def clean
      clear_session

      # completely empty database
      fixtures.each {|fixture| fixture.delete_existing_fixtures} if fixtures
      render_text "All data cleaned"
    end

  private

  	def clear_session
  	  @session[:user] = nil
  	end

    # add more test data fixtures by adding actions here
    # and calling them from your selenium test
  end

end