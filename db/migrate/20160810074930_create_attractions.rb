class CreateAttractions < ActiveRecord::Migration[5.0]
  def change
    create_table :attractions do |t|
      t.integer :city_id
      t.string :title
      t.text :description
    end
  end
end
