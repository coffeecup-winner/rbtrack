require 'spec_helper'

describe 'Projects authorization' do
  subject { page }
  let(:project) { FactoryGirl.create(:project_with_owner) }
  let(:team_member) { FactoryGirl.create(:user) }
  let(:user) { FactoryGirl.create :user }
  describe 'as non-signed-in user' do
    describe 'visiting Projects#new page' do
      before { visit new_project_path }
      it { should have_title('Sign in') }
    end
    describe 'submitting to the Projects#create action' do
      before { post projects_path }
      specify { response.should redirect_to(signin_path) }
    end
    describe 'visiting the projects index' do
      before { visit projects_path }
      it { should have_title('Sign in') }
    end
  end
  describe 'as team member' do
    before do
      membership = TeamMembership.new(user: team_member, project: project)
      membership.invitation_accepted = true
      membership.save!
      sign_in team_member
    end
    describe 'submitting to the TeamMemberships#invite action' do
      before { post invite_path(user_email: user.email, project_id: project.id) }
      specify { response.should redirect_to(project_path(project)) }
    end
  end
  describe 'as wrong user' do
    before do
      sign_in FactoryGirl.create(:user)
    end
    describe 'submitting to the TeamMemberships#invite action' do
      before { post invite_path(user_email: user.email, project_id: project.id) }
      specify { response.should redirect_to(root_path) }
    end
  end
end
