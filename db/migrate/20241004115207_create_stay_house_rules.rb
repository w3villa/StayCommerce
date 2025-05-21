class CreateStayHouseRules < ActiveRecord::Migration[7.2]
  def change
    create_table :stay_house_rules do |t|
      t.string :name
      t.timestamps
    end
  end
end
