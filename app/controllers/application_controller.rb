require 'jwt'

class ApplicationController < ActionController::API
	include ActionController::HttpAuthentication::Token::ControllerMethods
	before_action :authenticate_request 

	protected
		def authenticate_request
			authenticate_token || unauthorized
		end

		def authenticate_request
			authenticate_or_request_with_http_token do |token, options|
				jwt_token = JWT.decode(token, "SECRET_KEY")
				user = User.find_by(auth_token: jwt_token)
				def current_user
					@current_user ||= user
				end
			end
		end

		def unauthorized
			self.headers['WWW-Authenticate'] = 'Token realm=Application'
			render json: 'Bad Credentials', status: 401
		end
end
