class CreateStayContactUs < ActiveRecord::Migration[7.2]
  def change
    create_table :stay_contact_us do |t|
      t.string :name
      t.string :email
      t.string :mobile_number
      t.text :description

      t.timestamps
    end
  end
end
