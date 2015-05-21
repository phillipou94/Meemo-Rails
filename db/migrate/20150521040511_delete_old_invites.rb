class DeleteOldInvites < ActiveRecord::Migration
  def change
  	drop_table :invites
  	drop_table :post_invites
  end
end
