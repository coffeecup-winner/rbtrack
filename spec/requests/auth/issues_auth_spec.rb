require 'spec_helper'

describe 'Issues authorization' do
  subject { page }
  describe 'as non-signed-in user' do
    let(:user) { FactoryGirl.create :user }
    describe 'in the Issues controller' do
      let!(:issue) { FactoryGirl.create(:issue) }
      describe 'visiting the Issues#new page' do
        before { visit new_issue_path }
        it { should have_title('Sign in') }
      end
      describe 'visiting the Issues#edit page' do
        before { visit edit_issue_path(issue) }
        it { should have_title('Sign in') }
      end
      describe 'submitting to the Issues#create action' do
        before { post issues_path }
        specify { response.should redirect_to(signin_path) }
      end
      describe 'submitting to the Issues#update action' do
        before { put issue_path(issue) }
        specify { response.should redirect_to(signin_path) }
      end
      describe 'submitting to the Issues#destroy action' do
        before { delete issue_path(issue) }
        specify { response.should redirect_to(signin_path) }
      end
    end
  end
  describe 'as wrong user' do
    let(:user) { FactoryGirl.create :user }
    let(:wrong_user) { FactoryGirl.create :user, email: 'not_fred@example.com' }
    before { sign_in user }
    let!(:issue) { FactoryGirl.create(:issue) }
    describe 'as not the issue opener' do
      before do
        another_user = FactoryGirl.create(:user)
        sign_in another_user
      end
      describe 'visiting the Issues#edit page' do
        before { visit edit_issue_path(issue) }
        it { should_not have_title("Edit issue ##{issue.id}") }
      end
      describe 'submitting to the Issues#update action' do
        before { put issue_path(issue) }
        specify { response.should redirect_to(root_path) }
      end
      describe 'submitting to the Issues#destroy action' do
        before { delete issue_path(issue) }
        specify { response.should redirect_to(root_path) }
      end
    end
    describe 'as the issue\'s project team member' do
      before do
        team_member = FactoryGirl.create(:user)
        membership = TeamMembership.new(project: issue.project, user: team_member)
        membership.invitation_accepted = true
        membership.save!
        sign_in team_member
      end
      describe 'submitting to the Issues#update action' do
        before { put issue_path(issue) }
        specify { response.should redirect_to(issue_path(issue)) }
      end
      describe 'submitting to the Issues#update action, set_status: to_be_fixed' do
        before { put issue_path(issue, set_status: Status::TO_BE_FIXED) }
        specify { response.should redirect_to(issue_path(issue)) }
      end
      describe 'submitting to the Issues#update action, set_status: closed' do
        before { put issue_path(issue, set_status: Status::CLOSED) }
        specify { response.should redirect_to(root_path) }
      end
      describe 'submitting to the Issues#update action, set_status: fixed' do
        before { put issue_path(issue, set_status: Status::FIXED) }
        specify { response.should redirect_to(issue_path(issue)) }
      end
      describe 'submitting to the Issues#update action, set_status: by_design' do
        before { put issue_path(issue, set_status: Status::BY_DESIGN) }
        specify { response.should redirect_to(issue_path(issue)) }
      end
      describe 'submitting to the Issues#update action, set_status: wont_fix' do
        before { put issue_path(issue, set_status: Status::WONT_FIX) }
        specify { response.should redirect_to(issue_path(issue)) }
      end
      describe 'submitting to the Issues#update action, set_priority' do
        before { put issue_path(issue, set_priority: Priority::HIGH) }
        specify { response.should redirect_to(issue_path(issue)) }
      end
      describe 'submitting to the Issues#destroy action' do
        before { delete issue_path(issue) }
        specify { response.should redirect_to(root_path) }
      end
    end
    describe 'as the issue opener' do
      before { sign_in issue.user }
      describe 'submitting to the Issues#update action' do
        before { put issue_path(issue) }
        specify { response.should redirect_to(issue_path(issue)) }
      end
      describe 'submitting to the Issues#update action, set_status: to_be_fixed' do
        before { put issue_path(issue, set_status: Status::TO_BE_FIXED) }
        specify { response.should redirect_to(root_path) }
      end
      describe 'submitting to the Issues#update action, set_status: closed' do
        before { put issue_path(issue, set_status: Status::CLOSED) }
        specify { response.should redirect_to(issue_path(issue)) }
      end
      describe 'submitting to the Issues#update action, set_status: fixed' do
        before { put issue_path(issue, set_status: Status::FIXED) }
        specify { response.should redirect_to(root_path) }
      end
      describe 'submitting to the Issues#update action, set_status: by_design' do
        before { put issue_path(issue, set_status: Status::BY_DESIGN) }
        specify { response.should redirect_to(root_path) }
      end
      describe 'submitting to the Issues#update action, set_status: wont_fix' do
        before { put issue_path(issue, set_status: Status::WONT_FIX) }
        specify { response.should redirect_to(root_path) }
      end
      describe 'submitting to the Issues#update action, set_priority' do
        before { put issue_path(issue, set_priority: Priority::HIGH) }
        specify { response.should redirect_to(root_path) }
      end
    end
    describe 'as the admin' do
      before { sign_in FactoryGirl.create(:admin) }
      describe 'visiting the Issues#edit page' do
        before { visit edit_issue_path(issue) }
        it { should have_title("Edit issue ##{issue.id}") }
      end
      describe 'submitting to the Issues#update action' do
        before { put issue_path(issue) }
        specify { response.should redirect_to(issue_path(issue)) }
      end
      describe 'submitting to the Issues#update action, set_status' do
        before { put issue_path(issue, set_status: Status::CLOSED) }
        specify { response.should redirect_to(root_path) }
      end
      describe 'submitting to the Issues#update action, set_priority' do
        before { put issue_path(issue, set_priority: Priority::HIGH) }
        specify { response.should redirect_to(root_path) }
      end
      describe 'submitting to the Issues#destroy action' do
        before { delete issue_path(issue) }
        specify { response.should redirect_to(project_path(issue.project)) }
      end
    end
  end
end
