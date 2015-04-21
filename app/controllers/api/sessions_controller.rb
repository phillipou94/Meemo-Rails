class Api::SessionsController < Api::ApiController
	skip_before_filter :authenticate_user_from_token!, :only => [:login] #skip checking token when creating signing in

	#login
	def login
    	inputted_password = params[:session][:password]
    	user_email = params[:session][:email]
    	user = User.find_by(email: user_email)
	    if user && BCrypt::Engine.hash_secret(inputted_password, user.salt) == user.encrypted_password
	    	render status: 200, json: {
	    		status: 200,
		        message:"Successfully Logged In",
		        response: {
		          name: user.name,
		          email: user.email,
		          id: user.id,
		          authentication_token: user.authentication_token
		        }
		        
		      }.to_json
	    else
	    	render json: { status: 406, errors: "Invalid email or password" }, status: 406
	    end
  	end

  	def logout
  		if @current_user 
  			new_token = SecureRandom.urlsafe_base64(25).tr('lIO0', 'sxyz')
  			if @current_user.update_attribute(:authentication_token, new_token)
  				render status: 200, json: {
  					status: 200,
			        message:"Logout Successful",
			        response: {
			          name: @current_user.name,
			          email: @current_user.email,
			          id: @current_user.id,
			          authentication_token: @current_user.authentication_token
			        }
			        
			    }.to_json
			else 
				render json: { status: 422, errors: "Can't Logout" }, status: 422

			end 
		else 
			render json: { status: 422, errors: "Can't Find User" }, status: 422
		end 
		
  	end 
  	

end
