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
		  	status: 200,
		    message:"New Group Created",
		    response: {
		      id: new_group.id,
		      name: new_group.name,
		      members: secure_users(new_group)
		    }
		    
		  }.to_json
		  

		else
		  render status: 404, json: {
		  	status: 404,
		    errors: new_group.errors
		  }.to_json
		end
	end

	def show_users
		group = Group.find_by(id: params[:id])
		
		if group
		  members = secure_users(group)	#ensures that tokens and salts don't get revealed
		  render status: 200, json: {
		  	status: 200,
		    message:"Group Members",
		    response: {
		      id: group.id,
		      members: members
		    }
		    
		  }.to_json

		else
		  render status: 404, json: {
		  	status: 404,
		    errors: "Can't Find Group"
		  }.to_json
		end

	end 

	#{invitation:{group_id:1,user_id:1}}
	def invite_user
		group = Group.find_by(id: params[:invitation][:group_id])	
		user = User.find_by(id: params[:invitation][:user_id])
		if user && group 
			if !user_in_group?(user,group)
				user.enter_group(group)
				render status: 200, json: {
					status: 200,
			    	message:"Successfully Invited "+user.name+" to "+group.name,
			    	response: {
			      		id: group.id,
			      		members: secure_users(group)
			    	}
			    
			  	}.to_json
			  else
		  		render status: 401, json: {
		  			status: 401,
		    		errors: user.name+" is already in this group"
		  		}.to_json
		  	end 

		else
			render status: 404, json: {
				status: 404,
		    	errors: "Can't Find User Group Combination"
		  	}.to_json
		end 
		
	end 

	def leave_group
		group = Group.find_by(id: params[:group][:group_id])
		if group
			relationship = UserGroup.where(:user_id => @current_user.id).where(:group_id => group.id).first
			if relationship
				relationship.destroy
				render status: 200, json: {
					status: 200,
			    	message:"Successfully Left Group: "+group.name,
			    	response: {
			      		id: group.id,
			      		name: group.name
			    	}
			    
			  	}.to_json
			else 
				render status: 401, json: {
					status: 401,
			    	errors: "Failed to Leave Group"
			  	}.to_json
			end 
		else 
			render status: 401, json: {
				status: 401,
			    errors: "Couldn't Find User Group Combination"
			}.to_json
		end 	

	end 

	def get_posts
		group = Group.find_by(id: params[:id])
		if group
			render status: 200, json: {
				status: 200,
		    	message:"Found Posts",
		    	response: group.posts 
			}.to_json
		else 
			render status: 404, json: {
				status: 404,
			    errors: "Couldn't Find Group"
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
					status: 200,
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
			status: 201,
	    	message:"These People Do Not Belong to an Existing Group"
	  	}.to_json

	end 

		#potentially slow performance

	def get_groups_with_phone
		phone_number = params[:phone]
		if @current_user 
			invitations = Invite.where(phone_number: phone_number)
			if !invitations.empty?
				invitations.each do |invite|
					group = Group.find_by(id: invite.group_id)
					if group
						@current_user.enter_group(group)
						invite.destroy
					end 
				end 
				render status: 200, json: {
					status: 200,
				    message:"Successfully Joined Groups",
				    response: @current_user.groups
			    
				  }.to_json

			else 
				render status: 201, json: {
					status: 201,
				    message:"No Invites Found"
			    
				  }.to_json


			end 

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
