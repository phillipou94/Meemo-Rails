class PhonePost < ActiveRecord::Base
	belongs_to :phone
	belongs_to :post
	validates :post_id, :uniqueness => {:scope => [:phone_id]}
end
