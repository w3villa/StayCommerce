class ChangeDescriptionToTextInStayProperties < ActiveRecord::Migration[7.2]
  def change
    change_column :stay_properties, :description, :text
    change_column :stay_room_types, :description, :text
  end
end
