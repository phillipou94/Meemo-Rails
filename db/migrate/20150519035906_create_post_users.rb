class CreatePostUsers < ActiveRecord::Migration
  def change
    create_table :post_users do |t|
      t.integer :user_id
      t.integer :post_id
      t.string :group_name

      t.timestamps null: false
    end
  end
end
