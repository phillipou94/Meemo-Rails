class Api::InvitesController < Api::ApiController
	def invite
		people = params[:invite][:people]
		group_id = params[:invite][:group_id]
		people.each do |person|
			new_invite = Invite.new
			new_invite.group_id = group_id
			new_invite.phone_number = person[:phone]
			new_invite.name = person[:name]
			new_invite.save
		end 

		render status: 200, json: {
			status: 200,
		    message:"People were Successfully Invited",
		    response: people
	    
		  }.to_json

	end 

end
