json.extract! course, :id, :title, :description, :short_description, :price, :published, :published_at, :category_id, :level, :thumbnail_url, :duration_minutes, :created_at, :updated_at
json.url course_url(course, format: :json)
