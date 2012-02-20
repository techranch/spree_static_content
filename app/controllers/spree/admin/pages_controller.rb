class Spree::Admin::PagesController < Spree::Admin::ResourceController
  update.after :expire_cache

  def index
    @pages = Spree::Page.top_level
  end

  def new
    @pages = [Spree::Page.new(:title => 'No Parent')] + Spree::Page.all
    @page = @object
  end

  def edit
    @pages = [Spree::Page.new(:title => 'No Parent')] + Spree::Page.all - [@object]
    @page = @object
  end

  private
  def expire_cache
    expire_page :controller => '/spree/static_content', :action => 'show', :path => @object.slug
  end
end
