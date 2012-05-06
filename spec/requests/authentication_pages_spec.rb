require 'spec_helper'

describe 'Authentication' do
  subject { page }
  describe "Sign in page" do
    before { visit signin_path }
    it { should have_selector('h1', text: 'Sign in') }
    it { should have_selector('title', text: 'Sign in') }
    it { should have_link('Sign up', href: signup_path) }
  end
  describe 'sign in' do
    before { visit signin_path }
    describe 'with invalid information' do
      before { click_button 'Sign in' }
      it { should have_selector('title', text: 'Sign in') }
      it { should have_alert_error('Invalid') }
      describe 'after visiting another page' do
        before { click_link 'Home' }
        it { should_not have_alert_error('Invalid') }
      end
    end
    describe 'with valid information' do
      let(:user) { FactoryGirl.create(:user) }
      before { sign_in user }
      it { should have_selector('title', text: user.name) }
      it { should have_link('Profile', href: user_path(user)) }
      it { should have_link('Settings', href: edit_user_path(user)) }
      it { should have_link('Sign out', href: signout_path) }
      it { should_not have_link('Sign in', hfre: signin_path) }
      describe 'after signing out' do
        before { click_link 'Sign out' }
        it { should have_link 'Sign in' }
      end
    end
  end
  describe 'Authorization' do
    describe 'as non-signed-in user' do
      let(:user) { FactoryGirl.create :user }
      describe 'in the Users controller' do
        describe 'visiting the edit page' do
          before { visit edit_user_path(user) }
          it { should have_selector('title', text: 'Sign in') }
        end
        describe 'submitting to the update action' do
          before { put user_path(user) }
          specify { response.should redirect_to(signin_path) }
        end
      end
      describe 'when attempting to visit a protected page' do
        before do
          visit edit_user_path(user)
          #redirected to sign in
          sign_in user
        end
        describe 'after signing in' do
          it 'should render the desired protected page' do
            page.should have_selector('title', text: 'Edit profile')
          end
        end
      end
    end
    describe 'as wrong user' do
      let(:user) { FactoryGirl.create :user }
      let(:wrong_user) { FactoryGirl.create :user, email: 'not_fred@example.com' }
      before do
        visit signin_path
        sign_in user
      end
      describe 'visiting Users#edit page' do
        before { visit edit_user_path(wrong_user) }
        it { should_not have_selector('title', 'Edit profile') }
      end
      describe 'submitting a PUT request to the Users#update action' do
        before { put user_path(wrong_user) }
        specify { response.should redirect_to(root_path) }
      end
    end
  end
end
