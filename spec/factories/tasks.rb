require 'faker'

FactoryGirl.define do
  factory :task do
    finished false
    expiration Faker::Time.forward(7, :night)
    content Faker::Hacker.say_something_smart

    factory :friend_task do
    	content Faker::Hacker.say_something_smart
    end
  end

end
