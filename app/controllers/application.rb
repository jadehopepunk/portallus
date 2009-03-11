#require 'lib/form_helper_ext.rb'

require_dependency "login_system"

# The filters added to this controller will be run for all controllers in the application.
# Likewise will all the methods added be available for all controllers.
class ApplicationController < ActionController::Base
  include LoginSystem
    model :user

protected

  def redirect_to_login
    redirect_to(:controller => 'user', :action => 'login')
  end


end