include ApplicationHelper

RSpec::Matchers.define :have_alert_error do |text|
  match do |page|
    page.should have_selector('div.alert.alert-error', text: text)
  end
end

RSpec::Matchers.define :have_alert_success do
  match do |page|
    page.should have_selector('div.alert.alert-success')
  end
end

def sign_in(user)
  fill_in 'Email', with: user.email
  fill_in 'Password', with: user.password
  click_button 'Sign in'
  cookies[:remember_token] = user.remember_token
end