class CreatePostInvites < ActiveRecord::Migration
  def change
    create_table :post_invites do |t|
      t.string :phone_number
      t.string :name
      t.integer :post_id

      t.timestamps null: false
    end
  end
end
