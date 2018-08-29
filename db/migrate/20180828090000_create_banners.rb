class CreateBanners < ActiveRecord::Migration[5.0]
  def change
    create_table :banners do |t|
      t.string :image
      t.string :desc
      t.string :seq
      t.string :link
      t.string :status
      t.timestamps
    end
  end
end
