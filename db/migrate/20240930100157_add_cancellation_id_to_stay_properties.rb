class AddCancellationIdToStayProperties < ActiveRecord::Migration[7.2]
  def change
    add_reference :stay_properties, :cancellation_policy, foreign_key: { to_table: :stay_cancellation_policies }, null: true
  end
end
