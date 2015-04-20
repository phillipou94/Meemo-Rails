class AddLastPostAddedToGroup < ActiveRecord::Migration
  def change
  	add_column :groups, :last_post_type, :string
  	add_column :groups, :last_post_date, :date
  end
end
