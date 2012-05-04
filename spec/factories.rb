FactoryGirl.define do
  factory :user do
    name 'Fred Brown'
    email 'fred@example.com'
    password 'password'
    password_confirmation 'password'
  end
end