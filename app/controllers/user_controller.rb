class UserController < ApplicationController
  layout 'form'

  def login
    case @request.method
      when :post
      if @session[:user] = User.authenticate(@params[:user_email], @params[:user_password])
        flash['notice'] = "Login Successful"
        redirect_back_or_default(:controller => "section", :username => @session[:user].default_person, :action => "show")
      else
        flash.now['notice'] = "Login Unsuccessful"
        @login = @params[:user_email]
      end
    end
  end

  def signup
    @user = User.new(@params[:user])
        @user.new_password = true

    if @request.post? and @user.save
      @session[:user] = User.authenticate(@user.email, @params[:user][:password])
      flash['notice'] = "Your new Portallus account has been created."
      redirect_back_or_default(:controller => 'person', :action => 'create')
    end
  end

  def logout
    @session[:user] = nil
    flash['notice'] = "You have been logged out."
    redirect_back_or_default :controller => "section"
  end

  def edit
    @user = @session[:user]

    if @request.post?
      if (@params[:password]["password"] != '')
        @user.set_password(@params[:password]["password"], @params[:password]["password_confirmation"])
      end
      if @user.update_attributes(@params[:user])
        redirect_back_or_default :action => "welcome"
      end
    end
  end

  def welcome
  end

private

end
