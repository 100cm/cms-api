class CreateTemplates < ActiveRecord::Migration[5.0]
  def change
    create_table :templates do |t|
      t.string :name
      t.integer :menu_id
      t.string :template_theme
      t.timestamps
    end
  end
end
