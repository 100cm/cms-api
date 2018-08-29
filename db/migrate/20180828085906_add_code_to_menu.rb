class AddCodeToMenu < ActiveRecord::Migration[5.0]
  def change
    add_column :menus, :code, :string
  end
end
