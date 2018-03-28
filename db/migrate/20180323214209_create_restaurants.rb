class CreateRestaurants < ActiveRecord::Migration[5.1]
  def change
    create_table :restaurants do |t|
      t.string :name
      t.string :cuisine
      t.string :zipcode
      t.string :building
      t.string :street
      t.string :boro
      t.string :phone_number
      t.decimal :lat, null:true
      t.decimal :long, null:true

    end
  end
end
