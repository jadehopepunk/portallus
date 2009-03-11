require 'single_page/page.rb'

class SinglePage::ComponentController < ApplicationController
  include PortallusComponent
  uses_component_template_root
  layout nil

  def index
    load_section_tabs
    active_section
    no_page if (active_page == nil)
  end

  def edit
    unless can_administer?
      redirect_to_section_home
      return
    end

    @edit_page = active_page
    @section = active_section

    if @params["submit"] == "cancel"
      redirect_to_section_home
    elsif request.post? and @edit_page.update_attributes(@params[:edit_page])
      #flash['notice'] = 'Section "' + @edit_page.heading + '" was successfully updated.'
      redirect_to_section_home
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

  def active_page
    if nil == @page
      if active_section
        @page = Page.find(:first, :conditions => ['section_id = ?', active_section.id]);
      end

      if nil == @page
        @page = Page.new
        @page.section = active_section
      end
    end

    @page
  end

  def no_page
    can_administer? ? admin_no_page : blank
  end

  def blank
    render_action('blank')
  end

  def admin_no_page
    render_action('admin_blank')
  end

end
