class AddDeletedAtToStayStoreTranslations < ActiveRecord::Migration[7.2]
  def change
    add_column :stay_store_translations, :deleted_at, :datetime
  end
end
