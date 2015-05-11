require 'jwt'
require 'bcrypt'

class User
  include Mongoid::Document
  field :username, type: String
  field :password, type: String
  field :encrypted_password, type: String
  field :salt, type: String
  field :auth_token, type: String
  field :shares, type: Array, default: []

  embeds_many :tasks, cascade_callbacks: true

  validates :username, presence: true, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }
  validates :password, presence: true

  before_create :set_auth_token, :generate_hashed_password
  after_save :clear_password

  private
  	def set_auth_token
  		return if auth_token.present?
  		self.auth_token = create_jwt
  	end

  	def create_jwt
  		payload = {
  			username: self.username,
  			passsword: self.password
  		}
  		JWT.encode(payload, "SECRET_KEY")
  	end

  	def generate_hashed_password
  		if password.present?
  			self.salt = BCrypt::Engine.generate_salt
  			self.encrypted_password = BCrypt::Engine.hash_secret(password, salt)
  		end	
  	end

  	def clear_password
  		self.password = nil
  	end
end
