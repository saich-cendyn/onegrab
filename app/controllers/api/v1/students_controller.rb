module Api
  module V1
    class StudentsController < Api::ApiController
      def index
        @pagy, @students = pagy(User.where(role: User.roles[:student]).order(created_at: :desc))
        render json: {
            students: StudentSerializer.new(@students).serializable_hash,
            pagy: pagy_metadata(@pagy)
        }
      end
    end
  end
end
