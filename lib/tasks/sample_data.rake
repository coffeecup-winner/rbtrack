namespace :db do
  desc 'Fill database with sample data'
  task populate: :environment do
    def header(str)
      "===== #{str} ====="
    end

    puts header 'Populating database'
    puts header 'Admin'
    admin = User.create!(name: 'Fred Brown', email: 'fred@example.com',
                         password: 'password', password_confirmation: 'password')
    admin.toggle!(:admin)
    puts admin.name

    puts header 'Users'
    99.times do |n|
      name = Faker::Name.name
      email = "user#{n + 1}@example.com"
      password = 'password'
      User.create!(name: name, email: email, password: password, password_confirmation: password)
      puts "##{n} - #{name}"
    end

    puts header 'Projects'
    membership = TeamMembership.new(project: Project.create(name: 'rbtrack'), user: admin, owner: true)
    membership.invitation_accepted = true
    membership.save!
    49.times do |n|
      name = "Project #{n}"
      project = Project.create(name: name)
      user = User.find(rand(100)+1)
      membership = TeamMembership.new(project: project, user: user, owner: true)
      membership.invitation_accepted = true
      membership.save!
      puts "#{name} (#{user.name})"
    end

    puts header 'Issues'
    Project.all.each do |project|
      count = rand(100)
      count.times do |n|
        issue = Issue.new(subject: Faker::Lorem.words(num = 4).join(' '), description: "Description #{n}")
        issue.project = project
        issue.user = User.find(rand(100)+1)
        issue.save!
        issue.update_attribute(:status, rand(7))
        issue.update_attribute(:priority, rand(6))
        issue.save!
      end
      puts "#{project.name}: #{count} issues, #{project.issues.find_all { |i| !i.closed? }.count} active"
    end

    puts header 'Done populating'
  end
end