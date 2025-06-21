class User < ApplicationRecord

  # Include default devise modules as needed
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :lockable, :confirmable, :trackable,
         :jwt_authenticatable, jwt_revocation_strategy: JwtDenylist

  # Validations
  validates :email, presence: true
  validates :password, presence: true, on: :create
  validates :username, presence: true
  validates :phone, presence: true, format: { with: /\A\d{10}\z/, message: "must be 10 digits" }

  enum :role, {  member: 0, author: 1, teacher: 2, admin: 4 }

  has_many :authored_courses, class_name: 'Course', foreign_key: 'author_id'
  has_many :posts, foreign_key: :author_id


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
end
