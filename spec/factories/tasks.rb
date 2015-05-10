require 'faker'

FactoryGirl.define do
  factory :task do
    finished false
    expiration Faker::Time.forward(7, :night)
    content Faker::Lorem.sentence
  end

end
