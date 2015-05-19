class Post < ActiveRecord::Base
	has_many :post_users, :class_name => 'PostUser'
	has_many :users, :through => :post_users
	belongs_to :group
	validates :post_type, :presence => true,  :inclusion => { :in => ["text","photo"] }
end
