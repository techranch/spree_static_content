Spree::BaseController.class_eval do
  before_filter :set_pages


  private

  def set_pages
    @header_pages = Spree::Page.header_links.top_level.visible
    @footer_pages = Spree::Page.footer_links.top_level.visible
  end
end
