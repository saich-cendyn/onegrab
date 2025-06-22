class JwtDenylist < ApplicationRecord
  self.table_name = 'jwt_denylists'

  validates :jti, presence: true, uniqueness: true
  validates :exp, presence: true
  scope :expired, -> { where('exp < ?', Time.current) }

end
