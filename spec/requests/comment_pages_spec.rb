require 'spec_helper'

describe 'Comment pages' do
  subject { page }
  let(:issue) { FactoryGirl.create(:issue) }
  let(:user) { FactoryGirl.create(:user) }
  let(:message) { 'comment_message' }
  let(:submit) { 'Comment on this issue' }
  before { sign_in user }
  specify { issue.comments.count.should == 0 }
  describe 'commenting an issue' do
    before do
      visit issue_path(issue)
      fill_in message, with: 'comment text'
      click_button submit
    end
    it { should have_alert_success }
    it { should have_content('comment text') }
    it { should have_link(user.name, href: user_path(user)) }
    specify { issue.reload.comments.count.should == 1 }
  end
  describe 'invalid comment' do
    before do
      visit issue_path(issue)
      fill_in message, with: 'a' * 7
      click_button submit
    end
    it { should have_alert_error }
    specify { issue.reload.comments.count.should == 0 }
  end
end
