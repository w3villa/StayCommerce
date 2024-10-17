class AddColumnToStayChat < ActiveRecord::Migration[7.2]
  def change
    add_reference :stay_chats, :booking, foreign_key: { to_table: :stay_bookings }, null: true
    add_column :stay_chats, :chat_event, :integer
    add_column :stay_chats, :event_message, :text
  end
end
