class StaticContentController < Spree::BaseController
  layout :determine_layout

  def show
    path = case params[:path]
    when Array
      '/' + params[:path].join("/")
    when String
      '/' + params[:path]
    when nil
      request.path
    end

    @page = Spree::Page.visible.find_by_slug(path)
    unless @page
      return render_404
    end
    @page
  end

  private

  def determine_layout
    return @page.layout if @page and @page.layout.present?
    'spree/layouts/spree_application'
  end

  def accurate_title
    @page ? (@page.meta_title ? @page.meta_title : @page.title) : nil
  end
end

