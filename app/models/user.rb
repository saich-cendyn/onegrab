class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :lockable, :confirmable, :trackable

  validates :first_name, :last_name, :email, :username,  presence: true
  validates :password, presence: true, on: :create
  validates :phone, presence: true, format: { with: /\A\d{10}\z/, message: "must be 10 digits" }

  enum :role, {  member: 0, student: 1, author: 2, teacher: 3, admin: 4 }

  has_many :authored_courses, class_name: 'Course', foreign_key: 'author_id'
  has_many :posts, foreign_key: :author_id

  after_create :send_confirmation_email

  # Override Devise method to allow login via username or email
  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    login = conditions.delete(:login)&.downcase

    if login.present?
      where(conditions).where("lower(username) = :value OR lower(email) = :value", { value: login }).first
    else
      email = conditions[:email]&.downcase
      where(conditions).where("lower(email) = ?", email).first
    end
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  private

  def send_confirmation_email
    ConfirmationJob.perform_later(id)
  end
end
