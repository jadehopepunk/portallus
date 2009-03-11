
module PortallusComponent

  def active_section
    if (nil == @section)
      @section = @params[:section]
    end
    @section
  end

  def current_site
    active_section.site
  end

  def redirect_to_section_home
    redirect_to(:action => 'show', :name => active_section.to_param)
  end

  def can_administer?
    @can_administer = @params[:admin]
  end

end
