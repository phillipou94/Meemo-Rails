class Api::PostsController < Api::ApiController
	def create
		new_post = Post.new(post_params)
		if new_post.save 
			render status: 200, json: {
		    message:"Successfully Posted",
		    response: new_post
		    
		  }.to_json
		else
		   render status: 500, json: {
		    errors: new_post.errors
		  }.to_json
		end 
	end 

	def destroy
		post = params.find_by(id: params[:id])
		if post.destroy
			render status: 200, json: {
		    	message:"Post Destroyed"
		    
		  	}.to_json
		else 
			render status: 500, json: {
		    	errors: post.errors
		  	}.to_json
		end 

	end 

	def search
		search_string = "%" + params[:search] + "%"
		posts = @current_user.posts.includes(:title, :content)
		result = posts.where('title LIKE ? OR content LIKE ?',search_string,search_string)
		render status: 200, json: {
		    message:"Successfully Searched",
		    response: result
		}.to_json

	end 


	private
		def post_params
			params.require("post").permit(:post_type,:title,:content,:file_url,:user_id, :group_id)
		end 


end
