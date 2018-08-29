class CreateSessionKeys < ActiveRecord::Migration[5.0]
  def change
    create_table :session_keys do |t|
      t.string :session_key
      t.integer :user_id
      t.timestamps
    end
  end
end
