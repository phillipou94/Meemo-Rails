class Api::UsersController < Api::ApiController
	skip_before_filter :authenticate_user_from_token!, :only => [:create,:facebook_login] #skip checking token when creating user
	
	def create
		new_user = User.new(user_params)
		if new_user.save
		  render status: 200, json: {
		  	status: 200,
		    message:"New User Created",
		    response: {
		      name: new_user.name,
		      email: new_user.email,
		      id: new_user.id,
		      facebook_id: new_user.facebook_id,
		      device_id: new_user.device_id,
		      authentication_token: new_user.authentication_token
		    }
		    
		  }.to_json
		else
		  render status: 404, json: {
		  	status: 404,
		    errors: new_user.errors
		  }.to_json
		end
	end

	def facebook_login
		new_user = User.new(user_params)
		if new_user.save
		  render status: 200, json: {
		  	status: 200,
		    message:"New User Created",
		    response: {
		      name: new_user.name,
		      email: new_user.email,
		      id: new_user.id,
		      facebook_id: new_user.facebook_id,
		      device_id: new_user.device_id,
		      authentication_token: new_user.authentication_token
		    }
		    
		  }.to_json
		else
		
		  user = User.find_by(facebook_id:new_user.facebook_id)
		  render status: 200, json: {
		  	status: 200,
		    message:"Logged into Facebook",
		    response: {
		      name: user.name,
		      email: user.email,
		      id: user.id,
		      facebook_id: user.facebook_id,
		      device_id: user.device_id,
		      authentication_token: user.authentication_token
		    }
		    
		  }.to_json
		end

	end 

	#get user by id
	def show 
		user = User.find_by(id: params[:id])
		if !user.blank?
		  render status: 200, json: {
		  	status: 200,
		    message:"Found User",
		    response: {
		      name: user.name,
		      email: user.email,
		      id: user.id,
		      facebook_id: user.facebook_id
		    }
		  }.to_json
		else 
		  render status: 404, json: {
		  	status: 404,
		    errors: "Can't Find User"
		  }.to_json
		end 
	end 

	def get_posts
		if @current_user
			posts = @current_user.posts.paginate(:page => params[:page], :per_page => 10)
			render status: 200, json: {
				status: 200,
				message: "Found Posts",
				response: posts
			}.to_json
		else 
		  render status: 404, json: {
		  	status: 404,
		    errors: "Not Logged In"
		  }.to_json

		end 
	end 


	private

	    def user_params 
	      params.require("user").permit(:name,:password,:email, :facebook_id, :device_id)
	    end 

end
