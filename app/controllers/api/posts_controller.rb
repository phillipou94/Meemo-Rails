class Api::PostsController < Api::ApiController
	def create
		new_post = Post.new(post_params)
		if new_post.save 
			group = Group.find_by(id:new_post.group_id)
			if group 
				group.update_attribute(:last_post_type,new_post.post_type)
			end 
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

	def destroy
		post = Post.find_by(id: params[:id])
		if post.destroy
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
			params.require("post").permit(:post_type,:title,:content,:file_url,:user_id, :group_id)
		end 


end
