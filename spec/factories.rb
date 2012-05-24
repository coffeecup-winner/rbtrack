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
      project.after_create do |p|
        membership = TeamMembership.new(project: p, user: FactoryGirl.create(:user), owner: true)
        membership.invitation_accepted = true
        membership.save!
      end
    end
  end

  factory :issue do |issue|
    sequence(:subject) { |n| "Subject #{n}" }
    sequence(:description) { |n| "Description #{n}" }
    project { FactoryGirl.create(:project_with_owner) }
    user
    issue.after_create do |i|
      i.assignee = FactoryGirl.create(:user)
    end
  end
end