class CreateStayBlogs < ActiveRecord::Migration[7.2]
  def change
    create_table :stay_blogs do |t|
      t.string :title
      t.text :content
      t.references :user, null: false, foreign_key: { to_table: :stay_users }

      t.timestamps
    end
  end
end
