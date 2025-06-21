class CourseSerializer
  include JSONAPI::Serializer
  attributes :id, :title, :description, :short_description, :price, :level, :duration_minutes, :thumbnail_url
  attribute :category_name do |course|
    course.category&.name
  end
  attribute :author_name do |course|
    course.author&.username || course.author&.email
  end
end
