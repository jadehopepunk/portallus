require File.dirname(__FILE__) + '/../database_test_helper'

# Set salt to 'change-me' because thats what the fixtures assume.

class UserTest < Test::Unit::TestCase
	fixtures :users, :sections

	def test_auth
	    assert_equal  @bilbo, User.authenticate("bilbo@portallus.com", "oldsite")
		assert_nil    User.authenticate("nonbob@portallus.com", "test")
	end

	def test_disallowed_passwords
	    u = User.new
	    u.email = "nonbob@portallus.com"

		u.set_password("tiny", "tiny")
		assert(!u.save)
		assert(u.errors.invalid?('password'))
		
		u.set_password("hugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehuge", "hugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehuge")
		assert(!u.save)
		assert(u.errors.invalid?('password'))

		u.set_password("", "")
		assert(!u.save)
		assert(u.errors.invalid?('password'))

		u.set_password("bobs_secure_password", "bobs_secure_password")
		assert(u.save)
		assert(u.errors.empty?)
	end

	def test_collision
		u = User.new
	    u.email = "existingbob@portallus.com"
		u.password = u.password_confirmation = "bobs_secure_password"
		assert !u.save
	end

	def test_create
		u = User.new
	    u.email = "nonexistingbob2@portallus.com"
		u.password = u.password_confirmation = "bobs_secure_password2"

		assert u.save
	end

	def test_sha1
		u = User.new
	    u.email = "nonexistingbob@portallus.com"
		u.set_password("bobs_secure_password", "bobs_secure_password")		
		
		assert(u.save)		
	    assert_equal(u, User.authenticate("nonexistingbob@portallus.com", "bobs_secure_password"))
	end
	
	def test_default_person_param_defaults_to_nul
		u = User.new
		assert_equal(nil, u.default_person_param)
	end
	
end
