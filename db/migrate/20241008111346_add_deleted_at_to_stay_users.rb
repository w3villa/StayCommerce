class AddDeletedAtToStayUsers < ActiveRecord::Migration[7.2]
  def change
    unless column_exists?(:stay_users, :deleted_at)
      add_column :stay_users, :deleted_at, :datetime
    end
  end
end
