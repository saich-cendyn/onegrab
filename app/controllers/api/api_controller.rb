# frozen_string_literal: true
module Api
  class ApiController < ActionController::API
    include Pagy::Backend
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

    def current_user
      @current_user
    end

    def pagy_metadata(pagy)
      {
          page: pagy.page,
          limit: pagy.limit,
          count: pagy.count,
          pages: pagy.pages,
          next: pagy.next,
          prev: pagy.prev
      }
    end

  end
end
