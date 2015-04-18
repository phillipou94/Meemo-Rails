class Api::GroupsController < Api::ApiController

	def create
		new_group = Group.new(group_params)
		member_ids = params[:group][:user_ids] #include @current_user id
		if new_group.save
		  member_ids.each do |user_id|
		  	relationship = UserGroup.new
	    	relationship.group_id = new_group.id
	    	relationship.user_id = user_id
	    	relationship.save
		  end 	
		  render status: 200, json: {
		    message:"New Group Created",
		    response: {
		      id: new_group.id,
		      name: new_group.name,
		      members: secure_users(new_group)
		    }
		    
		  }.to_json
		  

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

	def leave_group
		group = Group.find_by_id(params[:group][:group_id])
		if group
			relationship = UserGroup.where(:user_id => @current_user.id).where(:group_id => group.id).first
			if relationship
				relationship.destroy
				render status: 200, json: {
			    	message:"Successfully Left Group: "+group.name,
			    	response: {
			      		id: group.id,
			      		name: group.name
			    	}
			    
			  	}.to_json
			else 
				render status: 500, json: {
			    	errors: "Failed to Leave Group"
			  	}.to_json
			end 
		else 
			render status: 500, json: {
			    errors: "Couldn't Find User Group Combination"
			}.to_json
		end 	

	end 

	def get_group_from_people
		groups = @current_user.groups
		people_ids = params[:people_ids]	#must include current_user id
		groups.each do |group|
			user_ids = Array.new
			group.users.each do |user|
				user_ids.push(user.id)
				if !people_ids.include?(user.id)
					break
				end
			end  
			if user_ids.uniq.sort == people_ids.uniq.sort
				render status: 200, json: {
			    	message:"These People are in Group: "+group.name,
			    	response: {
			      		id: group.id,
			      		name: group.name
			    	}
			    
			  	}.to_json
			  	return
			end 

		end 

		render status: 201, json: {
	    	message:"These People Do Not Belong to an Existing Group"
	  	}.to_json

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
