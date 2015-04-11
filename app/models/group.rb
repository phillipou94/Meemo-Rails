class Group < ActiveRecord::Base
	has_many :user_groups, :class_name => 'UserGroup'
	has_many :users, :through => :user_groups
'''
	def add_user(user)
		relationship = UserGroup.new
		relationship.user_id = user.id
		relationship.group_id = self.id
		if relationship.save

		else 

		end 
	end 
'''	
end
