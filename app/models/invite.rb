class Invite < ActiveRecord::Base
	belongs_to :group
	validates :phone_number, :uniqueness => {:scope => [:group_id]}
end
