# frozen_string_literal: true
FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    github_id { Faker::Number.number(digits: 10) }
    email { Faker::Internet.email }
    user_type { 'User' }
    public_repos { 3 }
    total_private_repos { 7 }
  end
end
