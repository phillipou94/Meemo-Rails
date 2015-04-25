class AddGroupIdToInvites < ActiveRecord::Migration
  def change
  	add_column :invites, :group_id, :integer
  	add_column :users, :phone_number, :string
  end
end
