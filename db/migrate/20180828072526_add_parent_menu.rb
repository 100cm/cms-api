class AddParentMenu < ActiveRecord::Migration[5.0]
  def change
    add_column :menus, :parent_menu, :string
  end
end
