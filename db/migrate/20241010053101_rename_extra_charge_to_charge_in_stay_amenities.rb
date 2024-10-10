class RenameExtraChargeToChargeInStayAmenities < ActiveRecord::Migration[7.2]
  def change
    rename_column :stay_amenities, :extra_charge, :charge
    rename_column :stay_room_amenities, :extra_charge, :charge
  end
end
