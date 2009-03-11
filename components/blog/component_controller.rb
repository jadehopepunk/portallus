require 'blog/blog_entry.rb'

class Blog::ComponentController < ApplicationController
  include PortallusComponent
  uses_component_template_root
  layout nil

  ACTIVE_ENTRY_COUNT = 5
  OLD_ENTRY_COUNT = 5

  def index
    if @params[:format] == "rss" then
      index_rss
    else
      @path = @params[:base_path]
      active_section
      active_entries
      old_entries
      navigation_links
      add_edit_links if can_administer?
      add_show_links
      new_entry_link if can_administer?
      edit_link if can_administer?
      description
    end
  end

  def index_rss
    @path = @request.protocol + @request.host_with_port + @params[:base_path]
    active_entries
    add_show_links
    render_action('index_rss')
  end

  def show
    @path = @params[:base_path]
    active_entry
    add_edit_link(active_entry) if can_administer?
  end

  def edit
    unless can_administer?
      redirect_to_section_home
      return
    end

    @edit_entry = active_entry
    @current_link =  active_section.to_param + '/edit/' + @edit_entry.to_param.to_s

    if @params["submit"] == "cancel"
      redirect_to_section_home
    elsif request.post? and @edit_entry.update_attributes(@params[:edit_entry])
      flash['notice'] = 'Blog entry "' + @edit_entry.heading + '" was successfully updated.'
      redirect_to_section_home
    end
  end

  def new
    unless can_administer?
      redirect_to_section_home
      return
    end

    @current_link =  active_section.to_param + '/new/'

    if request.get?
      @edit_entry = BlogEntry.new
    elsif @params["submit"] == "cancel"
      redirect_to_section_home
    elsif
      @edit_entry = BlogEntry.new(@params[:edit_entry])
      @edit_entry.section = active_section
      if @edit_entry.save
        flash['notice'] = 'Blog entry "' + @edit_entry.heading + '" was successfully created.'
        redirect_to_section_home
      end
    end
  end

  def edit_details
    unless can_administer?
      redirect_to_section_home
      return
    end

    @edit_detail = section_details
    @current_link =  active_section.to_param + '/edit_details/'

    if @params["submit"] == "cancel"
      redirect_to_section_home
    elsif request.post? and @edit_detail.update_attributes(@params[:edit_detail])
      #flash['notice'] = 'Section "blah" was successfully updated.'
      redirect_to(:action => 'show', :name => active_section.to_param)
    end

  end

  def self.params=(value)
    @params = value
  end

  def view_data
    result = Hash.new
    self.instance_variables.each do |var_name|
      result[var_name] = self.instance_eval(var_name)
    end
    result
  end

private

  def description
    detail = section_details
    @description = detail.text unless detail == nil
  end

  def section_details
    if (@section_details == nil)
      @section_details = BlogDetail.find(:first, :conditions => ['section_id = ?', active_section.record_id])

      if (@section_details == nil)
        @section_details = BlogDetail.new
        @section_details.section = active_section
      end
    end
    @section_details
  end

  def new_entry_link
    @new_entry_link = 'new'
  end

  def edit_link
    @edit_link = 'edit_details'
  end

  def add_edit_links
    add_action_links('edit')
  end

  def add_show_links
    add_action_links('show')
  end

  def add_edit_link(entry)
    add_action_link_to_entry('edit', entry)
  end

  def add_action_links(action)
    for entry in @entries
      add_action_link_to_entry(action, entry)
    end unless @entries == nil
  end

  def add_action_link_to_entry(action, entry)
    entry.instance_eval <<-END
      def #{action}_link
        '#{action}/' + to_param.to_s
      end
    END
  end

  def navigation_links
    older_link
    newer_link
  end

  def older_link
    @older_link = 'start=' + older_start.to_s unless older_start > entry_count
  end

  def newer_link
    @newer_link = 'start=' + newer_start.to_s unless user_start <= 0
  end

  def active_entries
    if nil == @entries
      if active_section
        @entries = entry_set(0, ACTIVE_ENTRY_COUNT)
      end
    end
    return @entries
  end

  def old_entries
    if nil == @old_entries
      if active_section
        @old_entries = entry_set(ACTIVE_ENTRY_COUNT, OLD_ENTRY_COUNT)
      end
    end
    return @old_entries
  end

  def active_entry
    if nil == @entry
      if active_section
        @entry = BlogEntry.find(:first, :conditions => ['id = ? AND section_id = ?', selected_entry_id, active_section.record_id]);
      end
    end
    return @entry
  end

  def entry_set(start, length)
    BlogEntry.find(
      :all,
      :conditions => ['section_id = ?', active_section.record_id],
      :limit => length,
      :offset => start + user_start,
      :order => 'created_at DESC');
  end

  def entry_count
    BlogEntry.count(['section_id = ?', active_section.record_id])
  end

  def user_start
    @params['start'].to_i
  end

  def older_start
    user_start + ACTIVE_ENTRY_COUNT
  end

  def newer_start
    result = user_start - ACTIVE_ENTRY_COUNT
    return (result < 0 ? 0 : result)
  end

  def selected_entry_id
    @params[:name]
  end

end
