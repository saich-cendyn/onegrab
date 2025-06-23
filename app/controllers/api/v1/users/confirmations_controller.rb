# app/controllers/api/v1/users/confirmations_controller.rb
module Api
  module V1
    module Users
      class ConfirmationsController < Devise::ConfirmationsController
        skip_before_action :verify_authenticity_token
        respond_to :json

        # POST /api/v1/users/confirmation
        def create
          user = User.find_by(email: resource_params[:email])
          if user.present?
            ConfirmationJob.perform_later(user.id)
            render json: { success: true, message: 'Confirmation instructions sent.' }, status: :ok
          else
            render json: { success: false, errors: ['User not found'] }, status: :unprocessable_entity
          end
        end

        # GET /api/v1/users/confirmation?confirmation_token=abcdef
        def show
          self.resource = resource_class.confirm_by_token(params[:confirmation_token])
          if resource.errors.empty?
            render json: { success: true, message: 'Account confirmed successfully.' }, status: :ok
          else
            if resource.errors.full_messages.include?("Email was already confirmed, please try signing in")
              render json: { success: true, message: "Email already confirmed. Please sign in." }, status: :ok
            else
              render json: { success: false, errors: resource.errors.full_messages }, status: :unprocessable_entity
            end
          end
        end
      end
    end
  end
end
