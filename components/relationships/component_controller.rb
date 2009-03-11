
class Relationships::ComponentController < ApplicationController
  include PortallusComponent
  uses_component_template_root
  layout nil

  def index
    @site = current_site
    @can_administer = can_administer?
    active_section
    @relationships = Relationship.find(:all, :conditions => ['source_id = ?', current_site.id])
    @show_form_link =  active_section.to_param + '/show_form/'
  end

  def display_form
    if !can_administer?
      render(:action => "hide_form")
      return
    end
    setup_create

    @relationship = Relationship.new
    @relationship.source = current_site

    @inverse_relationship = Relationship.new
    @inverse_relationship.destination = current_site
  end

  def create
    if !can_administer?
      render(:action => "hide_form")
      return
    end
    setup_create

    details = RelationshipDetails.new

    @relationship = Relationship.new(@params[:relationship])
    @relationship.source = current_site
    @relationship.relationship_details = details

    @inverse_relationship = Relationship.new(@params[:inverse_relationship])
    @inverse_relationship.destination = current_site
    @inverse_relationship.source = @relationship.destination
    @inverse_relationship.relationship_details = details

    @saved = false
    if @relationship.valid? && @inverse_relationship.valid? && @relationship.save && @inverse_relationship.save
      @saved = true
    end
  end

  def hide_form
  end

  def delete
    @deleted_id = params[:name]

    @relationship = Relationship.find(@deleted_id)
    @relationship.relationship_details.destroy

    @relationships = Relationship.find(:all, :conditions => ['source_id = ?', current_site.id])
    @empty = @relationships.length == 0
  end

  def suggestions
    @search_text = request.raw_post
    @field = @params['field']

    @relationships =
      Relationship.find(
        :all,
        :select => "*, count(description) as description_count",
        :group => 'description',
        :order => 'description_count DESC, description ASC',
        :conditions => ["description LIKE ?", "#{@search_text}%"],
        :limit => 10)

    if @relationships.length == 0 || (@relationships.length == 1 && @relationships[0].description == @search_text)
      @relationships = nil
    end

    @showing = flash[:showing_relationship_suggestions]

    flash[:showing_relationship_suggestions] = (@relationships != nil)
  end

private

  def setup_create
    @can_administer = can_administer?
    @current_link =  active_section.to_param + '/create/'
    @suggestions_link =  active_section.to_param + '/suggestions/'
  end

end
