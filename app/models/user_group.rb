class UserGroup < ActiveRecord::Base
	#user_group relationship
	belongs_to :user
	belongs_to :group
end
