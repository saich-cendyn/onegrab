# frozen_string_literal: true

class Api::V1::Users::SessionsController < Devise::SessionsController
  include ActionController::RequestForgeryProtection

  protect_from_forgery with: :null_session
  skip_before_action :verify_authenticity_token
  respond_to :json

  # POST /api/v1/users/login
  def create
    login_param = params.dig(:user, :login) || params.dig(:user, :email)
    password = params.dig(:user, :password)
    user = User.find_for_database_authentication(login: login_param)

    if user&.valid_password?(password)
      token = Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first
      render json: {
          message: 'Signed in successfully.',
          token: token,
          user: user.as_json(only: %i[id username email phone])
      }, status: :ok
    else
      render json: { errors: ['Invalid login or password'] }, status: :unauthorized
    end
  end


  # DELETE /api/v1/users/logout
  def destroy
    token = request.headers['Authorization']&.split(' ')&.last

    unless token.present?
      render json: { error: 'Authorization token missing' }, status: :unauthorized and return
    end

    secret = Rails.application.credentials.jwt.secret || ENV['DEVISE_JWT_SECRET_KEY']
    algorithm = Rails.application.credentials.jwt.algorithm || 'HS256'

    begin
      decoded_token = JWT.decode(token, secret, true, algorithm: algorithm, verify_expiration: true)
      payload = decoded_token.first

      raise JWT::DecodeError, 'Missing jti claim' unless payload['jti']
      raise JWT::DecodeError, 'Missing exp claim' unless payload['exp']

      JwtDenylist.create!(
          jti: payload['jti'],
          exp: Time.at(payload['exp'])
      )

      render json: { message: 'Logged out successfully.' }, status: :ok

    rescue JWT::ExpiredSignature
      render json: { error: 'Token already expired.' }, status: :unauthorized
    rescue JWT::DecodeError => e
      Rails.logger.warn "JWT decode failed during logout: #{e.message}"
      render json: { error: "Invalid token: #{e.message}" }, status: :unauthorized
    rescue ActiveRecord::RecordNotUnique
      render json: { message: 'Token already revoked.' }, status: :ok
    end
  end

  private

  def respond_to_on_destroy
    auth_header = request.headers['Authorization']
    if auth_header.present?
      token = auth_header.split(' ').last
      begin
        jwt_payload = JsonWebToken.decode(token)
        current_user = User.find_by(id: jwt_payload['sub'])
      rescue JWT::DecodeError, ActiveRecord::RecordNotFound
        current_user = nil
      end
    end

    if current_user
      render json: { status: 200, message: 'Logged out successfully.' }, status: :ok
    else
      render json: { status: 401, message: "Couldn't find an active session." }, status: :unauthorized
    end
  end
end
