class CreateStayAmenities < ActiveRecord::Migration[7.2]
  def change
    create_table :stay_amenities do |t|
      t.string :name
      t.text :description
      t.integer :position
      t.boolean :active, default: true
      t.decimal :extra_charge, precision: 8, scale: 2
      t.string :category
      t.timestamps
    end
  end
end
