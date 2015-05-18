class AddLastPostedUserToGroups < ActiveRecord::Migration
  def change
  	add_column :groups, :last_post_user_name, :string
  end
end
