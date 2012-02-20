class Spree::Page < ActiveRecord::Base
  default_scope :order => "position ASC"

  validates_presence_of :title
  validates_presence_of [:slug, :body], :if => :not_using_foreign_link?

  belongs_to :parent, :foreign_key => 'parent_id',  :class_name => "Spree::Page"
  has_many :children,  :foreign_key => 'parent_id',:class_name => "Spree::Page"

  scope :visible, where(:visible => true)
  scope :top_level, where(:parent_id => nil)
  scope :header_links, where(:show_in_header => true).visible
  scope :footer_links, where(:show_in_footer => true).visible
  scope :sidebar_links, where(:show_in_sidebar => true).visible


  before_save :update_positions_and_slug

  def initialize(*args)
    super(*args)
    last_page = Spree::Page.last
    self.position = last_page ? last_page.position + 1 : 0
  end

  def link
    if foreign_link.present?
      return foreign_link
    end
    self.slug
  end

private

  def update_positions_and_slug
    unless new_record?
      return unless prev_position = Spree::Page.find(self.id).position
      if prev_position > self.position
        Spree::Page.update_all("position = position + 1", ["? <= position AND position < ?", self.position, prev_position])
      elsif prev_position < self.position
        Spree::Page.update_all("position = position - 1", ["? < position AND position <= ?", prev_position,  self.position])
      end
    end

    if not_using_foreign_link?
      self.slug = slug_link
      Rails.cache.delete('page_not_exist/' + self.slug)
      self.children.each(&:save)
    end
    return true
  end

  def not_using_foreign_link?
    foreign_link.blank?
  end

  def slug_link
    page_slug = slug.split('/').last
    url = ensure_slash_prefix(page_slug)
    url.prepend(self.parent.slug) if self.parent.present?
    url
  end

  def ensure_slash_prefix(str)
    str.index('/') == 0 ? str : '/' + str
  end
end
