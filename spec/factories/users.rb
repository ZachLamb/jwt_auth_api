FactoryBot.define do
  factory :user do
    name { "John Doe" }
    sequence(:email) { |n| "user#{n}@form.com" }
    password { "password" }
    password_confirmation { "password" }
  end
end
