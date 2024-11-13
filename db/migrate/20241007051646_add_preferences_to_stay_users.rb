class AddPreferencesToStayUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :stay_users, :preferences, :json
  end
end
