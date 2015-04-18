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


	private
		def post_params
			params.require("post").permit(:post_type,:title,:content,:file_url,:user_id, :group_id)
		end 


end
