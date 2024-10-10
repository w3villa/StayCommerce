class CreateStayMessages < ActiveRecord::Migration[7.2]
  def change
    create_table :stay_messages do |t|
      t.string :body, null: false
      t.references :sender, null: false, foreign_key: { to_table: :stay_users }
      t.references :receiver, null: false, foreign_key: { to_table: :stay_users }
      t.references :chat, null: false, foreign_key: { to_table: :stay_chats }

      t.timestamps
    end
  end
end
