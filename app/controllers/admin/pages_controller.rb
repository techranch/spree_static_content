class Admin::PagesController < Spree::Admin::ResourceController
  include SpreeStaticContent::Engine.routes.url_helpers

  update.after :expire_cache
  before_filter :parent_select

  respond_to :html

  def index
    @pages = Spree::Page.top_level
    respond_with @pages
  end

  def new
    @page = Spree::Page.new
    respond_with @pages
  end

  def edit
    @page = Spree::Page.find(params[:id])
    respond_with @page
  end

	def create
	  @page = Spree::Page.new(params[:page])
    flash[:notice] = "#{@page.title} has been created successfully" if @page.save
    respond_with(@page, :location => admin_pages_path)
	end

  def update
    @page = Spree::Page.find(params[:id])
    if @page.update_attributes(params[:page])
      flash[:notice] = "#{@page.title} has been updated successfully"
    end
    respond_with(@page, :location => admin_pages_path)
  end

  def destroy
    @page = Spree::Page.find(params[:id])
    flash[:notice] = "#{@page.title} has been deleted successfully" if @page && @page.destroy
    redirect_to(admin_pages_path)
  end

  private
  def expire_cache
    expire_page :controller => '/spree/static_content', :action => 'show', :path => @object.slug
  end

  def parent_select
    @pages = [Spree::Page.new(:title => 'No Parent')] + Spree::Page.all
    if @object.present?
      @pages = @pages - [@object]
    end
  end
end
