include ApplicationHelper

RSpec::Matchers.define :have_alert_error do |text|
  match do |page|
    page.should have_selector('div.alert.alert-error', text: text)
  end
end
RSpec::Matchers.define :have_alert_success do |text|
  match do |page|
    page.should have_selector('div.alert.alert-success', text: text)
  end
end
RSpec::Matchers.define :have_title do |text|
  match do |page|
    page.should have_selector('title', text: text)
  end
end
RSpec::Matchers.define :have_header do |text|
  match do |page|
    page.should have_selector('h1', text: text)
  end
end
RSpec::Matchers.define :have_title_and_header do |text|
  match do |page|
    page.should have_title(text)
    page.should have_header(text)
  end
end

def sign_in(user)
  visit signin_path
  fill_in 'Email', with: user.email
  fill_in 'Password', with: user.password
  click_button 'Sign in'
  cookies[:remember_token] = user.remember_token
end

def create_project(name, user)
  sign_in user
  visit new_project_path
  fill_in 'Name', with: name
  click_button 'Create project'
end