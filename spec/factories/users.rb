# spec/factories/users.rb

require 'faker'

FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    country { Faker::Address.country }
  end
end
