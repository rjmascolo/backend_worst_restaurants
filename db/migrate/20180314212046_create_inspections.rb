class CreateInspections < ActiveRecord::Migration[5.1]
  def change
    create_table :inspections do |t|
      t.string :camis
      t.string :name
      t.string :building
      t.string :street
      t.string :boro
      t.string :zipcode
      t.string :cuisine
      t.string :inspection_date
      t.integer :score

    end
  end
end
