class CreateCountries < ActiveRecord::Migration[5.0]
  def change
    create_table :countries do |t|
      t.string :name
    end

    add_column :cities, :country_id, :integer
  end
end
