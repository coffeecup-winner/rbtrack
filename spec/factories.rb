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
    sequence(:name) { |n| "Project #{n}" }
    factory :project_with_owner do |project|
      project.after_create { |p| TeamMembership.create(project: p, user: FactoryGirl.create(:user), owner: true) }
    end
  end
end