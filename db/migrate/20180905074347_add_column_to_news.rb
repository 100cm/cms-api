class AddColumnToNews < ActiveRecord::Migration[5.0]
  def change
    add_column :news, :time, :string
    add_column :news, :cover, :string
  end
end
