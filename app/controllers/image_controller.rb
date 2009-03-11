
class ImageController < ApplicationController
  layout 'tinymce_plugin'
  before_filter :login_required, :only => [:upload]

  def upload
    if site == nil || site.user != @session[:user]
      flash['error'] = "Access Denied"
      render :action=> "error"
      return
    end

    if request.get?
      @image = Image.new
      @image.site = site
    else
      @image = Image.new(@params[:image])
      @image.site = site
      @image.create

      @image.save
    end
  end

private

  def site
    @site = Site.find(:first, :conditions => ["unique_name = ?", @params[:site]]) if @site == nil
    @site = @session[:user].default_person if @site == nil && @session[:user] != nil
    @site
  end

end
