class CreateStayRoleUsers < ActiveRecord::Migration[7.2]
  def change
    create_table :stay_role_users do |t|
      t.references :role, null: false, foreign_key: { to_table: :stay_roles }
      t.references :user, null: false, foreign_key: { to_table: :stay_users }

      t.timestamps
    end
  end
end
