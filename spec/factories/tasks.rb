require 'faker'

FactoryGirl.define do
  factory :task do
    finished "MyString"
    expiration "MyString"
    content "MyString"
    tags "MyString"
  end

end
