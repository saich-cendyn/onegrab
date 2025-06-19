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

  # Override Devise method to allow login via username or email
  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    login = conditions.delete(:login)&.downcase

    where(conditions).where(
        ["lower(username) = :value OR lower(email) = :value", { value: login }]
    ).first
  end
end
