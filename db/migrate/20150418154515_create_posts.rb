class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :type
      t.string :title
      t.text :content
      t.integer :user_id
      t.integer :group_id
      t.string :file_url

      t.timestamps null: false
    end
  end
end
