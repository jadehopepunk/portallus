class PersonaController < ApplicationController
  layout "form"

  def create
    unless @session[:user] and authorize?(@session[:user])
      store_location
      redirect_to(:controller => 'user', :action => 'signup')
      return
    end

    @persona = Persona.new(@params[:persona])
    @persona.user = @session[:user]
    @persona.update_unique_name
    if @request.post? and @persona.save
      flash['notice'] = "Your new SCA Persona website has been created."
      redirect_to(:controller => 'section', :action => 'show', :username => @persona)
    end
  end

end
