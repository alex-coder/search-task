class CreateActivities < ActiveRecord::Migration[5.0]
  def change
    create_table :activities do |t|
      t.integer :city_id
      t.string :title
      t.text :description
    end

    create_join_table :activities, :tags
    create_join_table :activities, :attractions
  end
end
