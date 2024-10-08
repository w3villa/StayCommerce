class CreateFriendlyIdSlugs < ActiveRecord::Migration[7.2]
  def change
    create_table :friendly_id_slugs do |t|
      t.string "slug"
      t.bigint "sluggable_id"
      t.string "sluggable_type", limit: 50
      t.string "scope"
      t.datetime "deleted_at"

      t.timestamps
    end
  end
end
