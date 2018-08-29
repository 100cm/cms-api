class CreateSystemConfigs < ActiveRecord::Migration[5.0]
  def change
    create_table :system_configs do |t|
      t.string :logo
      t.string :location
      t.string :phone
      t.string :email
      t.timestamps
    end
  end
end
