class CreateInvites < ActiveRecord::Migration
  def change
    create_table :invites do |t|
      t.string :phone_number
      t.string :name

      t.timestamps null: false
    end
  end
end
