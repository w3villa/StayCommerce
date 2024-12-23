class AddDeletedAttoStayProperty < ActiveRecord::Migration[7.2]
  def change
    add_column :stay_properties, :deleted_at, :datetime
    add_column :stay_rooms, :deleted_at, :datetime
  end
end
