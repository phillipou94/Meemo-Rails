class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.string :encrypted_password
      t.string :name
      t.string :facebook_id
      t.string :salt
      t.string :authentication_token

      t.timestamps null: false
    end
  end
end
