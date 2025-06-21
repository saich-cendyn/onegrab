module Api
  module V1
    class StudentsController < Api::ApiController
      def index
        pagy, students = pagy(Student.all)
        render json: {
            students: StudentSerializer.new(students).serializable_hash,
            pagy: pagy_metadata(pagy)
        }
      end
    end
  end
end
