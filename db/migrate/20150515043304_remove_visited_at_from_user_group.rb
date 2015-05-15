class RemoveVisitedAtFromUserGroup < ActiveRecord::Migration
  def change
  	remove_column :user_groups, :visited_at
  	add_column :user_groups,:visited,:integer
  end
end
