
class AboutPersona::ComponentController < ApplicationController
  include PortallusComponent
  uses_component_template_root
  layout nil

  def index
    load_section_tabs

    @section = active_section
    @details = details
    @site = current_site
  end

  def edit
    unless can_administer?
      redirect_to_section_home
      return
    end

    load_section_tabs
    @section = active_section
    @edit_details = details
    @site = current_site

    if @params["submit"] == "cancel"
      redirect_to_section_home
    elsif request.post?
      if @site.update_attributes(@params[:site]) && @edit_details.update_attributes(@params[:edit_details])
        redirect_to_section_home
      end
    end
  end

private

  def load_section_tabs
    @section_tabs = Array.new

    if can_administer?
      @section_tabs << {
        'title' => 'Edit',
        'action' => 'edit',
        'url' => @params[:base_path] + 'edit',
        'active' => false,
        'image' => '/images/22x22/edit.png'
      }
    end
  end

  def details
    if nil == @details
      if active_section
        @details = PersonaDetails.find(:first, :conditions => ['section_id = ?', active_section.id]);
      end

      if nil == @details
        @details = PersonaDetails.new
        @details.section = active_section
      end
    end

    @details
  end


end
