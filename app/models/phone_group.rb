class PhoneGroup < ActiveRecord::Base
	belongs_to :phone
	belongs_to :group
	validates :group_id, :uniqueness => {:scope => [:phone_id]}
end
