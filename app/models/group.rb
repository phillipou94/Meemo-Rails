class Group < ActiveRecord::Base
	has_many :user_groups, :class_name => 'UserGroup'
	has_many :users, :through => :user_groups
	has_many :posts
	has_many :invites
end
