class CreatePositions < ActiveRecord::Migration[5.0]
  def change
    create_table :positions do |t|
      t.string :name
      t.string :age
      t.string :sex
      t.text :requirement
      t.string :work_time
      t.string :money
      t.string :location
      t.string :benefit
      t.string :contact
      t.timestamps
    end
  end
end
