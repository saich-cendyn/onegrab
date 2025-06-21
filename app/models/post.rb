class Post < ApplicationRecord

  validates :title, presence: true, uniqueness: true, length: { maximum: 255 }
  validates :content, :author, :status, presence: true
  validates :published_at, presence: true, if: -> { published? }

  enum :status, { draft: 0, published: 1 }

  belongs_to :author, class_name: 'User'

end
