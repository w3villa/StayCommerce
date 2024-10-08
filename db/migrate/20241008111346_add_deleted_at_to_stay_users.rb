class AddDeletedAtToStayUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :stay_users, :deleted_at, :datetime
  end
end
