module Api
  module V1
    class CoursesController < Api::ApiController
      def index
        pagy, courses = pagy(Course.all)

        render json: {
            courses: CourseSerializer.new(courses).serializable_hash,
            pagy: pagy_metadata(pagy)
        }
      end
    end
  end
end