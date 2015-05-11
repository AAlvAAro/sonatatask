require 'faker'

FactoryGirl.define do
  factory :user do
  	id Faker::Lorem.characters(20)
    username Faker::Internet.email
    password Faker::Internet.password
    tasks { [FactoryGirl.build(:task)] }
  end

  factory :friend do
  	id Faker::Lorem.characters(20)
 	username Faker::Internet.email
  	password Faker::Internet.password

  	tasks { [FactoryGirl.build(:friend_task)] }
  end
end
