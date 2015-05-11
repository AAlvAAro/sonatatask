require 'jwt'

class ApplicationController < ActionController::API
	include ActionController::HttpAuthentication::Token::ControllerMethods
	rescue_from Exception, with: :internal_server_error

	# Handle common errors and send the appropriate response to the client
	def internal_server_error
		render json: { error: 'Internal Server Error' }, status: 500
	end

	def not_found
		render json: { error: 'Not Found' }, status: 404
	end

	def empty_ok_response
		render :json, {}, status: :ok
	end

	def respond_with_errors(errors)
		render :json, { errors: errors }, status: :unprocessable_entity
	end

	protected
		
		# Validate the user token for every request received
		def authenticate_request
			authenticate_token || unauthorized
		end

		def authenticate_token
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
