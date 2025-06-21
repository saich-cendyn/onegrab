json.extract! post, :id, :title, :content, :excerpt, :published_at, :status, :author_id, :created_at, :updated_at
json.url post_url(post, format: :json)
