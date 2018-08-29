class AddMenuIdToContent < ActiveRecord::Migration[5.0]
  def change
    add_column :contents, :menu_id, :integer
  end
end
