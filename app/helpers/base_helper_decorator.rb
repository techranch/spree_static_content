Spree::BaseHelper.module_eval do
  def render_static slug, params={}
    page = Spree::Page.visible.find_by_slug("/#{slug}")
    content = ""
    if page.present?
      header_content(page)
      content = page.body.html_safe
    elsif params.include?(:partial)
      content = render :partial => params[:partial]
    end
    @content = content
    content.html_safe
  end

  def header_content(page)
    head_content = ""
    content_for(:head, nil) do
      if page.meta_title.present?
        head_content << "<meta name='title' content='#{page.meta_title}'>"
      else
        head_content << "<meta name='title' content='#{page.title}'>"
      end
      head_content << "<meta name='keywords' content='#{page.meta_keywords}'>"
      head_content << "<meta name='keywords' content='#{page.meta_description}'>"
      head_content.html_safe
    end
    head_content
  end
end
