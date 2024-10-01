class CreateStayStores < ActiveRecord::Migration[7.2]
  def change
    create_table :stay_stores do |t|
      t.string "name"
      t.string "url"
      t.text "meta_description"
      t.text "meta_keywords"
      t.string "seo_title"
      t.string "mail_from_address"
      t.string "default_currency"
      t.string "code"
      t.boolean "default", default: false, null: false
      t.string "supported_currencies"
      t.string "facebook"
      t.string "twitter"
      t.string "instagram"
      t.string "default_locale"
      t.string "customer_support_email"
      t.bigint "default_country_id"
      t.text "description"
      t.text "address"
      t.string "contact_phone"
      t.string "new_order_notifications_email"
      t.bigint "checkout_zone_id"
      t.string "seo_robots"
      t.string "supported_locales"
      t.datetime "deleted_at"
      t.json "settings"

      t.timestamps
    end
  end
end
