class AddVisitedAtToUserGroup < ActiveRecord::Migration
  def change
  	add_column :user_groups, :visited_at, :date_time
  end
end
