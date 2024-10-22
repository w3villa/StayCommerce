class CreateStayTax < ActiveRecord::Migration[7.2]
  def change
    create_table :stay_taxes do |t|
      t.string "name"

      t.timestamps
    end
  end
end
