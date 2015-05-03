class AddFileUrlToGroups < ActiveRecord::Migration
  def change
  	add_column :groups, :file_url, :string
  end
end
