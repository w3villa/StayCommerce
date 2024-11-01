class AddReadAtToStayMessages < ActiveRecord::Migration[7.2]
  def change
    add_column :stay_messages, :read_at, :datetime
  end
end
