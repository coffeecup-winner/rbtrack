require 'spec_helper'

describe "Static pages" do
  describe "Home page" do
    it "should have the content 'rbTrack'" do
      visit '/static_pages/home'
      page.should have_content('rbTrack')
    end
    it "should have the correct title" do
      visit '/static_pages/home'
      page.should have_selector('title', :text => 'rbTrack')
    end
  end
end
