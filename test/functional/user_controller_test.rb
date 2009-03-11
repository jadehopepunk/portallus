require File.dirname(__FILE__) + '/../database_test_helper'
require 'user_controller'

# Set salt to 'change-me' because thats what the fixtures assume. 
User.salt = 'change-me'

# Raise errors beyond the default web-based presentation
class UserController; def rescue_action(e) raise e end; end

class UserControllerTest < Test::Unit::TestCase
  
  fixtures :users
  
  def setup
    @controller = UserController.new
    @request, @response = ActionController::TestRequest.new, ActionController::TestResponse.new
    @request.host = "localhost"
  end
  
  def test_auth_bob
    @request.session[:return_to] = "/bogus/location"

    post :login, :user_login => "bob", :user_password => "test"
    assert_session_has :user

    assert_equal @bob, @response.session[:user]
    
    assert_redirect_url "http://localhost/bogus/location"
  end
  
#  def test_signup
#    @request.session[:return_to] = "/bogus/location"
#
#    post :signup, :user => { :email => "bob@portallus.com", :login => "newbob", :password => "newpassword", :password_confirmation => "newpassword" }
#    assert_session_has :user
#    
#    assert_redirect_url "http://localhost/bogus/location"
#  end
#
  def test_bad_signup
    @request.session[:return_to] = "/bogus/location"

    post :signup, :user => { :login => "newbob", :password => "newpassword", :password_confirmation => "wrong" }
    assert_invalid_column_on_record "user", :password
    assert_success
    
    post :signup, :user => { :login => "yo", :password => "newpassword", :password_confirmation => "newpassword" }
    assert_invalid_column_on_record "user", :login
    assert_success

    post :signup, :user => { :login => "yo", :password => "newpassword", :password_confirmation => "wrong" }
    assert_invalid_column_on_record "user", [:login, :password]
    assert_success
  end

  def test_invalid_login
    post :login, :user_login => "bob", :user_password => "not_correct"
     
    assert_session_has_no :user
    
    assert_template_has "login"
  end
  
  def test_login_logoff

    post :login, :user_login => "bob", :user_password => "test"
    assert_session_has :user

    get :logout
    assert_session_has_no :user

  end
  
end
