class PersonController < ApplicationController
	layout "form"

	def create
	    unless @session[:user] and authorize?(@session[:user])
			store_location
			redirect_to(:controller => 'user', :action => 'signup')
			return
	    end

		@person = Person.new(@params[:person])
		@person.user = @session[:user]
		@person.update_unique_name
		if @request.post? and @person.save
			flash['notice'] = "Your new Portallus website has been created."
			redirect_to(:controller => 'section', :action => 'show', :username => @person)
		end
	end

end
