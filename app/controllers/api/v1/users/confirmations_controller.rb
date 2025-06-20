# app/controllers/api/v1/users/confirmations_controller.rb
module Api
  module V1
    module Users
      class ConfirmationsController < Devise::ConfirmationsController
        respond_to :json

        # POST /api/v1/users/confirmation
        def create
          self.resource = resource_class.send_confirmation_instructions(resource_params)
          if successfully_sent?(resource)
            render json: { message: 'Confirmation instructions sent.' }, status: :ok
          else
            render json: { errors: resource.errors.full_messages }, status: :unprocessable_entity
          end
        end

        # GET /api/v1/users/confirmation?confirmation_token=abcdef
        def show
          self.resource = resource_class.confirm_by_token(params[:confirmation_token])
          if resource.errors.empty?
            render json: { message: 'Account confirmed successfully.' }, status: :ok
          else
            render json: { errors: resource.errors.full_messages }, status: :unprocessable_entity
          end
        end
      end
    end
  end
end
