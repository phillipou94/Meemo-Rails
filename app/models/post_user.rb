class PostUser < ActiveRecord::Base
	belongs_to :post 
	belongs_to :user
	validates :user_id, :uniqueness => {:scope => :post_id}	#ensures uniqueness for both

end
