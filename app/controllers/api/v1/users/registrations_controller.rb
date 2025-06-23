# frozen_string_literal: true

class Api::V1::Users::RegistrationsController < Devise::RegistrationsController
  include ActionController::RequestForgeryProtection
  protect_from_forgery with: :null_session
  skip_before_action :verify_authenticity_token
  respond_to :json

  def create
    build_resource(sign_up_params)
    resource.role = User.roles[:student]

    if resource.save
      token = generate_jwt_token(resource)
      render json: {
          message: 'Signed up successfully.',
          user: UserSerializer.new(resource).serializable_hash[:data][:attributes],
          token: token
      }, status: :created
    else
      render json: {
          status: { message: "User couldn't be created successfully. #{resource.errors.full_messages.to_sentence}" },
          errors: resource.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  private

  def sign_up_params
    params.require(:user).permit(:first_name, :last_name, :username, :email, :phone, :password, :password_confirmation)
  end

  def jwt_secret
    ENV['JWT_SECRET_KEY'] || Rails.application.credentials.jwt.secret
  end

  def jwt_algorithm
    'HS256'
  end

  def generate_jwt_token(user)
    payload = {
        sub: user.id,
        exp: 1.day.from_now.to_i,
        iat: Time.now.to_i,
        jti: SecureRandom.uuid
    }
    JWT.encode(payload, jwt_secret, jwt_algorithm)
  end
end
