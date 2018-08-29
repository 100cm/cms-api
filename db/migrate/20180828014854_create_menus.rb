class CreateMenus < ActiveRecord::Migration[5.0]
  def change
    create_table :menus do |t|
      t.string :name
      t.integer :parent_id
      t.string :menu_category
      t.timestamps
    end
  end
end
