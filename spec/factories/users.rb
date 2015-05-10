require 'faker'
require 'jwt'

FactoryGirl.define do
  factory :user do
    usernamme Faker::Internet.email
    password Faker::Internet.password
    token JWT.encode({username: username, password: password}, 'SECRET_KEY')
  end

end
