class AddEventsToStayMessages < ActiveRecord::Migration[7.2]
  def change
    add_column :stay_messages, :event_for, :integer
    add_column :stay_messages, :event_message, :text
    change_column_null :stay_messages, :sender_id, true
    change_column_null :stay_messages, :receiver_id, true
  end
end
