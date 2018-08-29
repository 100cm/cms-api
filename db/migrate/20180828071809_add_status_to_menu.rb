class AddStatusToMenu < ActiveRecord::Migration[5.0]
  def change
    add_column :menus,:status,:string ,default:'active'
  end
end
