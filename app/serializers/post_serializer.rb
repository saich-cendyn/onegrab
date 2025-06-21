class PostSerializer
  include JSONAPI::Serializer
  attributes :id, :title, :content, :excerpt, :published_at, :status

  attribute :author_name do |post|
    post.author&.username || post.author&.email
  end
end
