class CreateStayStayUserPaypals < ActiveRecord::Migration[7.2]
  def change
    create_table :stay_user_paypals do |t|
      t.string :email
      t.references :user, null: false, foreign_key: { to_table: :stay_users }
      t.timestamps
    end
  end
end
