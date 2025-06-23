class Enquiry < ApplicationRecord
  validates :name, :email, :phone, presence: true
end
