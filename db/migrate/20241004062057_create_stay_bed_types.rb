class CreateStayBedTypes < ActiveRecord::Migration[7.2]
  def change
    create_table :stay_bed_types do |t|
      t.string :name

      t.timestamps
    end
  end
end
