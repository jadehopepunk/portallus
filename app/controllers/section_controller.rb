class SectionController < ApplicationController

  def show
    if current_site == nil
      redirect_to('')
      return
    end

    load_sites
    current_site
    load_admin_options
    load_menu
    store_location

    display_component_action('index')
  end

  def new
    @section_types = SectionType.find_all_user_createable(current_site.type_name, active_section)
    @section = root_section
    newchild
  end

  def newchild
    @section_types = SectionType.find_all_user_createable(current_site.type_name, active_section)
    current_site
    load_menu
    load_admin_options

    if request.get?
      @edit_section = Section.new
      @edit_section.section_type = @section_types[0] if  @section_types.length == 1
    else
      @edit_section = Section.new(@params[:edit_section])
      @edit_section.site = current_site
      @edit_section.section_type = @section_types[0] if  @section_types.length == 1

      active_section.add_child(@edit_section)
      if @params["submit"] == "cancel"
        redirect_to(:action => 'show', :name => active_section)
      elsif @edit_section.save
        flash['notice'] = 'Section "' + @edit_section.heading + '" was successfully created.'
        redirect_to(:action => 'show', :name => @edit_section.to_param)
      else
        active_section.remove_child(@edit_section)
      end
    end
  end

  def edit
    current_site
    unless can_administer?
      redirect_to_login
      return
    end

    load_admin_options
    load_menu
    display_component_action('edit')
  end

  def delete
    current_site
    unless can_administer?
      redirect_to_login
      return
    end

    active_section.destroy
    redirect_to(:action => 'show', :name => parent_section)
  end

  def rename
    current_site
    unless can_administer?
      redirect_to_login
      return
    end

    load_admin_options
    load_menu
    @edit_section = active_section
    if @params["submit"] == "cancel"
      redirect_to(:action => 'show', :name => active_section)
    elsif request.post? and @edit_section.update_attributes(@params[:edit_section])
      redirect_to(:action => 'show', :name => @edit_section)
    end
  end

  def move_up
    current_site
    unless can_administer?
      redirect_to_login
      return
    end

    active_section.move_backward();
    redirect_to(:action => 'show', :name => active_section)
  end

  def move_down
    current_site
    unless can_administer?
      redirect_to_login
      return
    end

    active_section.move_forward() == false;
    redirect_to(:action => 'show', :name => active_section)
  end

private

  def load_sites
    @sites = @session[:user].sites unless @session[:user] == nil
  end

  def current_site
    if nil == @person
      if @params[:username]
        @person = Site.find(:first, :conditions => ["unique_name = ?", @params[:username]])
      else
        @person = Site.find(:first, :conditions => ["unique_name = ?", 'portallus'])
      end
    end
    @person
  end

  def load_menu
    @menu_title = 'Main Menu'

    if (nil == parent_section)
      @sections = []
    else
      @sections = parent_section.children
      unless parent_section.is_root?
        @menu_title = parent_section.heading
        @menu_title_name = parent_section.to_param
      end
    end
  end

  def load_admin_options
    if can_administer?
      @node_admin_options = Array.new
      @node_admin_options << {
        'title' => 'New Section',
        'action' => 'new',
        'image' => '/images/16x16/newsection.gif'}

      @section_admin_options = Array.new
      @section_admin_options << {
        'title' => 'New Sub-Section',
        'action' => 'newchild',
        'image' => '/images/16x16/newsubsection.gif'}
      @section_admin_options << {
        'title' => 'Rename',
        'action' => 'rename',
        'image' => '/images/16x16/config.gif'}
      @section_admin_options << {
        'title' => 'Move Up',
        'action' => 'move_up',
        'image' => '/images/16x16/up.gif'}
      @section_admin_options << {
        'title' => 'Move Down',
        'action' => 'move_down',
        'image' => '/images/16x16/down.gif'}
      @section_admin_options << {
        'title' => 'Delete',
        'action' => 'delete',
        'image' => '/images/16x16/delete.gif'}
    end
  end

  def active_section
    if nil == @section
      if (section_name)
        @section = current_site.find_first_section(section_name)
      end

      if nil == @section
        @section = root_section
        @section = @section.children[0] unless @section.children.length == 0
      end
    end

    @section
  end

  def parent_section
    (active_section.parent == nil ? active_section : active_section.parent)
  end

  def root_section
    current_site.root_section
  end

  def display_component_action(action)
    if (active_section != nil && !active_section.is_root? && active_section.component != nil)
      component_controller = active_section.component + '/component'

      action = component_query_action unless component_query_action == nil

      @section_content = render_component_as_string(:controller => component_controller, :action => action, :params => current_component_params)

      render(:text => @section_content) if format != nil || request.xml_http_request?
      redirect_to(@headers["location"]) if @headers["location"]
    end
  end

  def current_component_params
    component_params = param_hash
    component_params[:section] = active_section
    component_params[:admin] = true if can_administer?
    component_params[:name] = component_query_id
    component_params[:format] = format
    component_params[:base_path] =  '/people' + '/' + current_site.to_param.to_s + '/' + active_section.hierarchy_name + '/'

    return component_params
  end

  def component_query_array
    if nil == @query_array then
      if nil == section_name then
        @query_array = Array.new
      else
        @query_array = active_section.trim_name_heirarchy_from_array(section_name)
      end
    end
    return @query_array
  end

  def component_query_action
    return (component_query_array[0] =~ /=/) ? 'index' : component_query_array[0]
  end

  def component_query_id
    return (component_query_array[1] =~ /=/) ? nil : component_query_array[1]
  end

  def param_hash
    result = Hash.new

    result.update(@params)

    value_index = 1

    for param in component_query_array
      parts = param.split('=')
      if parts.length == 2 then
        key = parts[0]
        value = parts[1]
      else
        key = 'value' + value_index.to_s
        ++value_index
        value = param
      end
      result[key] = value
    end

    result
  end

  def can_administer?
    current_site != nil && current_site.can_be_administered_by?(@session[:user])
  end

  def section_name
    load_name_and_format
    @name_array
  end

  def format
    load_name_and_format
    @format
  end

  def load_name_and_format
    if @name_array == nil then
      @name_array = @params[:name]
      if @name_array != nil && !@name_array.empty? then
        last_name_parts = @name_array.last.split(".")
        @name_array[@name_array.length - 1] = last_name_parts[0]
        @format = last_name_parts[1]
      end
    end
  end

end
