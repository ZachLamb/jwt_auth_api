FactoryBot.define do
  factory :widget do
    sequence(:name) { |n| "Widget #{n}" }
  end
end
