class ModifyCancellationPolicyOnProperties < ActiveRecord::Migration[7.2]
  def change
    remove_foreign_key :stay_properties, :stay_cancellation_policies

    add_foreign_key :stay_properties, :stay_cancellation_policies, column: :cancellation_policy_id, on_delete: :nullify
  end
end
