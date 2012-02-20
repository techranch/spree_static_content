class Spree::Admin::PagesController < Spree::Admin::ResourceController
  update.after :expire_cache
  before_filter :parent_select

  def index
    @pages = Spree::Page.top_level
  end

  def new
    @page = @object
  end

  def edit
    @page = @object
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
