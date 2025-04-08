class AddFieldToStayUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :stay_users, :country, :string
    add_column :stay_users, :about_me, :text
    add_column :stay_users, :country_code, :string
  end
end
