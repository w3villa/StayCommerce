class CreateStayCancellationPolicies < ActiveRecord::Migration[7.2]
  def change
    create_table :stay_cancellation_policies do |t|
      t.string :name
      t.text :description
      t.timestamps
    end
  end
end
