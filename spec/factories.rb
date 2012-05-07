FactoryGirl.define do
  factory :user do
    sequence(:name) { |n| n == 1 ? 'Fred Brown' : "Person #{n}" }
    sequence(:email) { |n| "#{n == 1 ? 'fred' : n}@example.com" }
    password 'password'
    password_confirmation 'password'
    factory :admin do
      admin true
    end
  end

  factory :project do
    name 'rbtrack'
  end
end