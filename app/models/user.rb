class User < ActiveRecord::Base
	has_many :user_groups, :class_name => 'UserGroup'
	has_many :groups, :through => :user_groups
	has_many :posts
	
	EMAIL_REGEX = /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
	validates :email, uniqueness: true, :format => EMAIL_REGEX, if: 'email.present?'
	validates :name, :presence => true
	validates :password, :presence => true , if: 'facebook_id.blank?'
	validates :facebook_id, uniqueness: true, if: 'facebook_id.present?'
	#note:password is not in the usermodel, encrypted_password is.
	before_save :encrypt_password, :ensure_authentication_token!
	after_save :clear_password

	attr_accessor :password

	''' Password Encryption '''
	def encrypt_password
	  if password.present?
	    self.salt = BCrypt::Engine.generate_salt
	    self.encrypted_password= BCrypt::Engine.hash_secret(password, salt)
	  end
	end

	def clear_password
	  self.password = nil
	end

	'''Authentication Token'''
	def ensure_authentication_token!
	    if authentication_token.blank?
	      self.authentication_token = generate_authentication_token
	    end
	end

    def generate_authentication_token
    	loop do
      		token = generate_secure_token_string
      		break token unless User.where(authentication_token: token).first
    	end
    end

    def generate_secure_token_string
    	SecureRandom.urlsafe_base64(25).tr('lIO0', 'sxyz')
  	end

  	def reset_authentication_token!
    	self.authentication_token = generate_authentication_token
  	end

  	'''GROUPS '''
  	def enter_group(group)
  		if !group.users.include?(self)
  			relationship = UserGroup.new
		    relationship.group_id = group.id
		    relationship.user_id = self.id
		    relationship.save
		    group.update_attribute(:last_post_type,"add")    
		end 
	end


end
