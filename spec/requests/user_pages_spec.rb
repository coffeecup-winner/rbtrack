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
    end
  end
  describe 'Profile page' do
    let(:user) { FactoryGirl.create(:user) }
    before { visit user_path(user) }
    it { should have_selector('h1', text: user.name) }
    it { should have_selector('title', text: user.name) }
  end
end
