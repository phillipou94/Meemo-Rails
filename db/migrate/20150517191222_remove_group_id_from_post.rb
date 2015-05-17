class RemoveGroupIdFromPost < ActiveRecord::Migration
  def change
  	remove_column :posts, :group_id
  end
end
