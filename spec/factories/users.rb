FactoryBot.define do
  factory :user do
    email { "testuser@example.com" }
    password { "password123" }
    password_confirmation { "password123" }
  end
end