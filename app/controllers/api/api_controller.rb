module Api #what this module will be called
	class ApiController < ApplicationController 
		respond_to :json
		before_filter :authenticate_user_from_token!
		skip_before_filter :authenticate_user_from_token!, :only => [:wake_up]

		def wake_up
			render status: 200, json: {
        		message: "Server Awake"
      		}.to_json
		end 

		def authenticate_user_from_token!
		    user_auth_token = request.headers["API-TOKEN"].presence	#this will require tokens on headers
		    user = User.where(authentication_token: user_auth_token).first	#find user with that authenticadtion token
		    if user && Devise.secure_compare(user.authentication_token, user_auth_token)
		      #set @current_user as global variable
		      @current_user = user
		    else 
		    	render status: 500, json: {
        			errors: "Invalid Token"
      			}.to_json

		    end
		
		end

		def current_user
			if @current_user 
				render status: 200, json: {
					status: 200,
			        message:"Logged In",
			        response: {
			          name: @current_user.name,
			          email: @current_user.email,
			          id: @current_user.id,
			          authentication_token: @current_user.authentication_token
			        }
			        
			      }.to_json
			else 
				render status: 401, json: {
					status: 401,
        			errors: "Invalid Token"
      			}.to_json

			end 
			
		end
	end  
end 
