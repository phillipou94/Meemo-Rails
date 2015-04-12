class Api::FileUploaderController < ApplicationController
	def upload
		s3 = AWS::S3.new(:access_key_id => ENV['S3_KEY'],:secret_access_key => ENV['S3_SECRET'])
	    bucket = s3.buckets['meemo-photos']
	    data = Base64.decode64(params[:file][:encoded_string].to_s)
	    type = params[:file][:content_type].to_s
	    extension = params[:file][:extension].to_s
	    name = ('a'..'z').to_a.shuffle[0..7].join + ".#{extension}"
	    obj = bucket.objects.create(name,data,{content_type:type,acl:"public_read"})
	    url = obj.public_url().to_s
	    render status: 200, json: {
		    message:"Upload Successful",
		    response: {
		      url:url,
		    }
		    
		  }.to_json
	end 

end

