class ChangePosition < ActiveRecord::Migration[5.0]
  def change
    change_column :positions,:benefit,:text
    change_column :positions,:work_time,:text
  end
end
