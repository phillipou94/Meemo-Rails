class Api::PostsController < Api::ApiController
	def create
		new_post = Post.new(post_params)
		new_post.user_id = @current_user.id
		new_post.user_name = @current_user.name
		if new_post.save 
			if new_post.group_id
				group = Group.find_by(id:new_post.group_id)
				if group 
					group.update_attributes(:last_post_type => new_post.post_type,:last_post_user_name => @current_user.name)
					group.users.each do |user|
						relationship = PostUser.new
						relationship.post_id = new_post.id
						relationship.user_id = user.id
						relationship.save
					end 
				end 
			end 
			facebook_ids = params[:post][:facebook_ids]
			if facebook_ids
				facebook_ids.each do |facebook_id|
					user = User.find_by(facebook_id:facebook_id)
					if user
						relationship = PostUser.new
						relationship.post_id = new_post.id
						relationship.user_id = user.id
						relationship.save
					end
				end 
			end

			relationship = PostUser.new
			relationship.post_id = new_post.id
			relationship.user_id = @current_user.id
			relationship.save 

			numbers = params[:post][:phone_numbers]
			invite_users(numbers,new_post)


			render status: 200, json: {
				status: 200,
			    message:"Successfully Posted",
			    response: new_post
		    
			  }.to_json
		else
		   render status: 404, json: {
		   	status: 404,
		    errors: new_post.errors
		  }.to_json
		end 
	end 

	def invite_users(people,post)
		if people 
			people.each do |person|
				phone = get_phone_model(person[:phone])
				relationship = PhonePost.new
				relationship.post_id = post.id
				relationship.phone_id = phone.id
				relationship.save
			end 
		end

	end 

	def destroy
		post = Post.find_by(id: params[:id])
		if post.destroy
			#delete from AWS
			if post.file_url
				s3 = AWS::S3.new(:access_key_id => ENV['S3_KEY'],:secret_access_key => ENV['S3_SECRET'])
		    	file = s3.buckets['meemo-photos'].objects[post.file_url]
				file.delete()
			end 
			render status: 200, json: {
				status: 200,
		    	message:"Post Destroyed"
		    
		  	}.to_json
		else 
			render status: 404, json: {
				status: 404,
		    	errors: post.errors
		  	}.to_json
		end 

	end 

	def hide_post
		post = Post.find_by(id:params[:id])
		if post
			relationship = PostUser.where(:user_id =>@current_user.id).where(:post_id=>post.id).first
			if relationship.destroy
				render status: 200, json: {
					status: 200,
			    	message:"Hidden"
			    
			  	}.to_json
			else
				render status: 404, json: {
					status: 404,
			    	errors: post.errors
			  	}.to_json 

		  	end
		end 

	end 

	def search
		search_string = "%" + params[:search] + "%"
		posts = @current_user.posts
		result = posts.where('title LIKE ? OR content LIKE ?',search_string,search_string)
		render status: 200, json: {
			status: 200,
		    message:"Successfully Searched",
		    response: result
		}.to_json

	end 


	private
		def post_params
			params.require("post").permit(:post_type,:title,:content,:file_url, :group_id)
		end

		def get_phone_model(number)
			phone = Phone.find_by(number:number)
			if phone.nil? 
				new_phone = Phone.new
				new_phone.number = number
				new_phone.access_code = generate_access_code
				new_phone.save
				return new_phone
			else 
				return phone
			end 
		end

		def generate_access_code
		    options = "0123456789".split("")
		    result = ""
		    for i in 0..5
		        result += options.sample
		    end
		    
		    return result
		end   


end
