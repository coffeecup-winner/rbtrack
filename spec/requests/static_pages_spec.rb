require 'spec_helper'

describe "Static pages" do
  subject { page }
  describe "Home page" do
    before { visit root_path }
    it { should have_selector('h1', text: 'rbTrack') }
    it { should have_title(full_title('')) }
    it 'Should have the correct links' do
      click_link 'Sign up'
      page.should have_selector('h1', text: 'Sign up')
    end
    describe 'sign up button' do
      it { should have_link('Sign up', href: signup_path) }
      describe 'when user is logged in' do
        before { sign_in FactoryGirl.create(:user) }
        it { should_not have_link('Sign up') }
      end
    end
  end
end
