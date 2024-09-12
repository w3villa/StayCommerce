class CreateStayChats < ActiveRecord::Migration[7.2]
  def change
    create_table :stay_chats do |t|
      t.references :sender, null: false, foreign_key: { to_table: :stay_users }
      t.references :receiver, null: false, foreign_key: { to_table: :stay_users }
      t.references :property, null: false, foreign_key: { to_table: :stay_properties }

      t.timestamps
    end
  end
end
