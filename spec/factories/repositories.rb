# frozen_string_literal: true
FactoryBot.define do
  factory :repository do
    name { 'github-repository' }
    github_id { Faker::Number.number(digits: 10) }
    node_id { Faker::Number.number(digits: 10) }
    full_name { 'github/github-repository' }
    private { true }
    description { 'This is a description' }
    security { 'enabled' }
    github_created_at { Time.current }
    github_updated_at { Time.current + 1.day }
    topics { ['ruby', 'api'] }
    user
  end
end
