class CreatePhoneGroups < ActiveRecord::Migration
  def change
    create_table :phone_groups do |t|
      t.integer :group_id
      t.integer :phone_id

      t.timestamps null: false
    end
  end
end
