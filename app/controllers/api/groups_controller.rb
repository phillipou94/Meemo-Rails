class Api::GroupsController < Api::ApiController

	def create
		new_group = Group.new(group_params)
		if new_group.save
		  render status: 200, json: {
		    message:"New Group Created",
		    response: {
		      id: new_group.id,
		      name: new_group.name,
		    }
		    
		  }.to_json
		  @current_user.enter_group(new_group)

		else
		  render status: 500, json: {
		    errors: new_group.errors
		  }.to_json
		end
	end

	def show_users
		group = Group.find_by_id(params[:id])
		
		if group
		  members = secure_users(group)	#ensures that tokens and salts don't get revealed
		  render status: 200, json: {
		    message:"Group Members",
		    response: {
		      id: group.id,
		      members: members
		    }
		    
		  }.to_json

		else
		  render status: 500, json: {
		    errors: "Can't Find Group"
		  }.to_json
		end

	end 

	#{invitation:{group_id:1,user_id:1}}
	def invite_user
		group = Group.find_by_id(params[:invitation][:group_id])	
		user = User.find_by_id(params[:invitation][:user_id])
		if user && group 
			if !user_in_group?(user,group)
				user.enter_group(group)
				render status: 200, json: {
			    	message:"Successfully Invited "+user.name+" to "+group.name,
			    	response: {
			      		id: group.id,
			      		members: secure_users(group)
			    	}
			    
			  	}.to_json
			  else
		  		render status: 500, json: {
		    		errors: user.name+" is already in this group"
		  		}.to_json
		  	end 

		else
			render status: 500, json: {
		    	errors: "Can't Find User Group Combination"
		  	}.to_json
		end 
		
	end 

	private
		def group_params
			params.require("group").permit(:name)
		end 

		def secure_users(group)
			members = Array.new
			group.users.each do |user|
			  	secure_user = {:name => user.name,:id => user.id}
			  	members.push(secure_user)
			end 
			return members
		end 

		def user_in_group?(user,group)
			return UserGroup.where(:user_id=>user.id).where(:group_id=>group.id).any?
		end 
end
