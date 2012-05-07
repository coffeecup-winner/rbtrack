namespace :db do
  desc 'Fill database with sample data'
  task populate: :environment do
    admin = User.create!(name: 'Fred Brown', email: 'fred@example.com',
                         password: 'password', password_confirmation: 'password')
    admin.toggle!(:admin)
    99.times do |n|
      name = Faker::Name.name
      email = "user#{n + 1}@example.com"
      password = 'password'
      User.create!(name: name, email: email, password: password, password_confirmation: password)
    end

    TeamMembership.create(project: Project.create(name: 'rbtrack'), user: admin, owner: true)
    49.times do |n|
      name = "Project #{n}"
      project = Project.create(name: name)
      TeamMembership.create(project: project, user: User.find(rand(100)), owner: true)
    end
  end
end