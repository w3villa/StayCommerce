class AddStateToProperties < ActiveRecord::Migration[7.2]
  def change
    add_column :stay_properties, :property_state, :string, default: 'waiting_for_approval'
  end
end
