class Api::V1::Users::SessionsController < Devise::SessionsController
  protect_from_forgery with: :null_session
  skip_before_action :verify_authenticity_token
  skip_before_action :verify_signed_out_user, on: [:destroy]

  # POST /api/v1/users/login
  def create
    login_param = params.dig(:user, :login) || params.dig(:user, :email)
    password = params.dig(:user, :password)

    user = User.find_for_database_authentication(login: login_param)

    if user&.valid_password?(password)
      token = generate_jwt_token(user)

      render json: {
          message: 'Signed in successfully.',
          user: UserSerializer.new(user).serializable_hash[:data][:attributes],
          token: token
      }, status: :created
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

    begin
      payload = decode_jwt_token(token)

      if payload['jti'].present? && payload['exp'].present?
        JwtDenylist.create!(
            jti: payload['jti'],
            exp: Time.at(payload['exp'])
        )
      end

      render json: { message: 'Logged out successfully.' }, status: :ok

    rescue JWT::ExpiredSignature
      render json: { error: 'Token already expired.' }, status: :unauthorized
    rescue JWT::DecodeError => e
      render json: { error: "Invalid token: #{e.message}" }, status: :unauthorized
    rescue ActiveRecord::RecordNotUnique
      render json: { message: 'Token already revoked.' }, status: :ok
    end
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

  def decode_jwt_token(token)
    JWT.decode(token, jwt_secret, true, algorithm: jwt_algorithm).first
  end
end
