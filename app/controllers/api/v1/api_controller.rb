class ApiController < ActionController::API
  protect_from_forgery with: :null_session
  before_action :authenticate_user!

  private
  def authenticate_user!
    token = request.headers['Authorization']&.split(' ')&.last
    decoded_token = JsonWebToken.decode(token)

    if decoded_token && !JwtDenylist.exists?(jti: decoded_token['jti'])
      @current_user = User.find(decoded_token['sub'])
    else
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Unauthorized' }, status: :unauthorized
  end
end
