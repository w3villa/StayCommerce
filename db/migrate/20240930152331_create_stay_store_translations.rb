class CreateStayStoreTranslations < ActiveRecord::Migration[7.2]
  def change
    create_table :stay_store_translations do |t|
      t.references :stay_store, index: true, foreign_key: true
      t.string :name
      t.text :meta_description
      t.text :meta_keywords
      t.string :seo_title
      t.string :facebook
      t.string :twitter
      t.string :instagram
      t.string :customer_support_email
      t.text :description
      t.string :address
      t.string :contact_phone
      t.string :new_order_notifications_email
      t.string "locale"

      t.timestamps
    end
  end
end
