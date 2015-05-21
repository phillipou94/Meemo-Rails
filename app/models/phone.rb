class Phone < ActiveRecord::Base
	validates :number, uniqueness: true
	validates :access_code, uniqueness: true
	has_many :phone_groups, :class_name => 'PhoneGroup', dependent: :destroy
	has_many :phone_posts, :class_name => 'PhonePost', dependent: :destroy
	has_many :groups, :through => :phone_groups
	has_many :posts, :through => :phone_posts
end
