module Api #what this module will be called
	class ApiController < ApplicationController 
		respond_to :json
		before_filter :authenticate_user_from_token!

		def authenticate_user_from_token!
		    user_auth_token = request.headers["API-TOKEN"].presence	#this will require tokens on headers
		    user = User.where(authentication_token: user_auth_token).first	#find user with that authenticadtion token
		    if user && Devise.secure_compare(user.authentication_token, user_auth_token)
		      #sign in user
		      @current_user = user
		    else 
		    	render status: 500, json: {
        			errors: "Invalid Token"
      			}.to_json

		    end
		
		end 
		
	end 
end 
