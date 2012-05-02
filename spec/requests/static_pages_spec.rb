require 'spec_helper'

describe "Static pages" do
  subject { page }
  describe "Home page" do
    before { visit root_path }
    it { should have_selector('h1', text: 'rbTrack') }
    it { should have_selector('title', text: full_title('')) }
    it 'Should have the correct links' do
      click_link 'Sign up'
      page.should have_selector('h1', text: 'Sign up')
    end
  end
end
