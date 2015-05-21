class CreatePhonePosts < ActiveRecord::Migration
  def change
    create_table :phone_posts do |t|
      t.integer :post_id
      t.integer :phone_id

      t.timestamps null: false
    end
  end
end
