class PostInvite < ActiveRecord::Base
	belongs_to :post
	validates :phone_number, :uniqueness => {:scope => [:post_id]}
end
