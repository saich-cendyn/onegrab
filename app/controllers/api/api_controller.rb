# frozen_string_literal: true
module Api
  class ApiController < ActionController::API
    include Pagy::Backend
    before_action :authenticate_user!

    private

    def authenticate_user!
      token = request.headers['Authorization']&.split(' ')&.last

      unless token
        render json: { error: 'Authorization token missing' }, status: :unauthorized and return
      end

      begin
        decoded_token = JsonWebToken.decode(token)
        if decoded_token && !JwtDenylist.exists?(jti: decoded_token['jti'])
          @current_user = User.find(decoded_token['sub'])
        else
          render json: { error: 'Unauthorized or token revoked' }, status: :unauthorized
        end
      rescue JWT::ExpiredSignature
        render json: { error: 'Token has expired' }, status: :unauthorized
      rescue JWT::DecodeError => e
        render json: { error: "Invalid token: #{e.message}" }, status: :unauthorized
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'User not found' }, status: :unauthorized
      end
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
