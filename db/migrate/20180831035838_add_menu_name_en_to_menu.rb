class AddMenuNameEnToMenu < ActiveRecord::Migration[5.0]
  def change
    add_column :menus, :name_en, :string
  end
end
