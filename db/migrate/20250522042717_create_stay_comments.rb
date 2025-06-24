class CreateStayComments < ActiveRecord::Migration[7.2]
  def change
    create_table :stay_comments do |t|
      t.string :name
      t.string :email
      t.text :content
      t.integer :parent_id

      t.timestamps
    end
  end
end
