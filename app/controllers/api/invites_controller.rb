class Api::InvitesController < Api::ApiController
	def invite
		people = params[:invite][:people]
		group_id = params[:invite][:group_id]
		people.each do |person|
			phone = get_phone_model(person[:phone])
			relationship = PhoneGroup.new
			relationship.group_id = group_id
			relationship.phone_id = phone.id
			relationship.save
		end 

		render status: 200, json: {
			status: 200,
		    message:"People were Successfully Invited",
		    response: people
	    
		  }.to_json

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
