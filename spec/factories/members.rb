FactoryBot.define do
  factory :member do
    username { "testuser" }
    email { "test@example.com" }
    phone { "1234567890" }
    password { "password123" }
    password_confirmation { "password123" }
    confirmed_at { Time.current }
  end
end
