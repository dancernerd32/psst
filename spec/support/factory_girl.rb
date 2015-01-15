require "factory_girl"

FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    sequence(:username) { |n| "user#{n}" }
    first_name "John"
    last_name "Example"
    password "password"
    password_confirmation "password"
  end

  factory :post do
    sequence(:body) { |n| "text#{n}" }
    user
  end

end
