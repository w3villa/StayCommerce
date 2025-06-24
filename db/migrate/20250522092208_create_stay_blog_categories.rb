class CreateStayBlogCategories < ActiveRecord::Migration[7.2]
  def change
    create_table :stay_blog_categories do |t|
      t.references :blog, null: false, foreign_key: { to_table: :stay_blogs }
      t.references :category, null: false, foreign_key: { to_table: :stay_categories }

      t.timestamps
    end
  end
end
