class DestroyLastUpdatedColumnInGroups < ActiveRecord::Migration
  def change
  	remove_column :groups, :last_post_date
  end
end
