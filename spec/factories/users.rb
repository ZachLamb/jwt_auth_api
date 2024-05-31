FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@form.com" }
    password { "password" }
  end
end
