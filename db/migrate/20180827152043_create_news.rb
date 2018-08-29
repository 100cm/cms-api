class CreateNews < ActiveRecord::Migration[5.0]
  def change
    create_table :news do |t|
      t.string :title
      t.string :subtitle
      t.text :content
      t.string :desc
      t.string :status
      t.timestamps
    end
  end
end
