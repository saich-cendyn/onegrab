class Student < ApplicationRecord
  GENDERS = %w[male female other].freeze

  attribute :status, :string
  attribute :progress_status, :string

  validates :name, presence: true, length: { maximum: 100 }
  validates :email, presence: true, uniqueness: true, format: {
      with: URI::MailTo::EMAIL_REGEXP, message: "must be a valid email address"
  }
  validates :phone, presence: true, format: {
      with: /\A\d{10}\z/, message: "must be exactly 10 digits"
  }
  validates :address, length: { maximum: 255 }, allow_blank: true
  validates :gender, inclusion: { in: GENDERS }, allow_blank: false
  validates :dob, presence: true

  enum :status, { active: 'active', inactive: 'inactive', graduated: 'graduated' }, suffix: true
  enum :progress_status, { not_started: 'not_started', in_progress: 'in_progress', completed: 'completed' }, suffix: true

  has_many :course_enrollments
  has_many :courses, through: :course_enrollments


  def image_url
    return self[:image_url] if self[:image_url].present?

    case gender&.downcase
    when 'male'
      ActionController::Base.helpers.asset_path('boy.png')
    when 'female'
      ActionController::Base.helpers.asset_path('girl.png')
    else
      ActionController::Base.helpers.asset_path('default-avatar.png')
    end
  end

end
