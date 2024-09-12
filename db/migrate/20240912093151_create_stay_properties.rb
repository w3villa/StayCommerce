class CreateStayProperties < ActiveRecord::Migration[7.2]
  def change
    create_table :stay_properties do |t|
      t.string :title
      t.string :description
      t.boolean :active, default: true
      t.date :availability_start
      t.date :availability_end
      t.integer :user_id
      t.integer :room_id
      t.integer :address_id

      t.timestamps
    end
  end
end
