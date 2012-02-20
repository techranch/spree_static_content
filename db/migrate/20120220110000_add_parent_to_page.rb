class AddParentToPage < ActiveRecord::Migration
  def change
    add_column :spree_pages, :parent_id, :integer
  end
end
