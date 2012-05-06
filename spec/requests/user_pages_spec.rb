require 'spec_helper'

describe 'User pages' do
  subject { page }
  describe 'Sign up page' do
    before { visit signup_path }
    let(:submit) { 'Create account' }
    it { should have_selector('h1', text: 'Sign up') }
    it { should have_selector('title', text: full_title('Sign up'))}
    describe 'with invalid information' do
      it 'should not create a user' do
        expect { click_button submit }.not_to change(User, :count)
      end
      describe 'error messages' do
        before { click_button submit }
        it { should have_selector('title', text: 'Sign up') }
        it { should have_content('error') }
        it { should_not have_content('digest') }
      end
    end
    describe 'with valid information' do
      before do
        fill_in 'Name', with: 'Fred Brown'
        fill_in 'Email', with: 'fred@example.com'
        fill_in 'Password', with: 'password'
        fill_in 'Confirmation', with: 'password'
      end
      it 'should create a user' do
        expect { click_button submit }.to change(User, :count).by(1)
      end
      describe 'after saving the user' do
        before { click_button submit }
        let(:user) { User.find_by_email('fred@example.com') }
        it { should have_selector('title', text: user.name) }
        it { should have_selector('div.alert.alert-success', text: 'Welcome') }
        it { should have_link 'Sign out' }
      end
    end
  end
  describe 'Profile page' do
    let(:user) { FactoryGirl.create(:user) }
    before { visit user_path(user) }
    it { should have_selector('h1', text: user.name) }
    it { should have_selector('title', text: user.name) }
  end
  describe 'Edit' do
    let(:user) { FactoryGirl.create(:user) }
    before {
      visit signin_path
      sign_in user
      visit edit_user_path(user)
    }
    describe 'page' do
      it { should have_selector('h1', text: 'Update your profile') }
      it { should have_selector('title', text: 'Edit profile') }
      it { should have_link('Change', href: 'http://gravatar.com/emails') }
    end
    describe 'with invalid information' do
      before { click_button 'Save changes' }
      it { should have_content('error') }
    end
    describe 'with valid information' do
      let(:new_name) { 'Simply Fred' }
      let(:new_email) { 'simply.fred@example.com' }
      before do
        fill_in 'Name', with: new_name
        fill_in 'Email', with: new_email
        fill_in 'Password', with: user.password
        fill_in 'Confirmation', with: user.password
        click_button 'Save changes'
      end

      it { should have_selector('title', text: new_name) }
      it { should have_alert_success }
      it { should have_link('Sign out', href: signout_path) }
      describe 'updated user' do
        let(:updated_user) { user.reload }
        specify { updated_user.name.should == new_name }
        specify { updated_user.email.should == new_email }
      end
    end
  end
  describe 'Index' do
    before do
      visit signin_path
      sign_in FactoryGirl.create(:user)
      FactoryGirl.create(:user, name: 'Fred\'s buddy', email: 'buddy@example.com')
      FactoryGirl.create(:user, name: 'Fred\' worst enemy', email: 'evil.guy@example.com')
      visit users_path
    end
    it { should have_selector('title', text: 'All users') }
    it 'should list each user' do
      User.all.each do |user|
        page.should have_selector('li', text: user.name)
      end
    end
  end
end
