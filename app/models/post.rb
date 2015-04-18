class Post < ActiveRecord::Base
	belongs_to :user
	belongs_to :group
	validates :post_type, :presence => true,  :inclusion => { :in => ["text","photo"] }
end
