require 'spec_helper'

describe 'Authentication' do
  subject { page }
  describe "Sign in page" do
    before { visit signin_path }
    it { should have_selector('h1', text: 'Sign in') }
    it { should have_title('Sign in') }
    it { should have_link('Sign up', href: signup_path) }
  end
  describe 'sign in' do
    before { visit signin_path }
    describe 'with invalid information' do
      before { click_button 'Sign in' }
      it { should have_title('Sign in') }
      it { should have_alert_error('Invalid') }
      it { should_not have_link('Projects', href: projects_path) }
      it { should_not have_link('Users', href: users_path) }
      it { should_not have_link('Profile') }
      it { should_not have_link('Settings') }
      it { should_not have_link('Sign out', href: signout_path) }
      it { should have_link('Sign in', hfre: signin_path) }
      describe 'after visiting another page' do
        before { click_link 'Home' }
        it { should_not have_alert_error('Invalid') }
      end
    end
    describe 'with valid information' do
      let(:user) { FactoryGirl.create(:user) }
      before { sign_in user }
      it { should have_title(user.name) }
      it { should have_link('Projects', href: projects_path) }
      it { should have_link('Users', href: users_path) }
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
          it { should have_title('Sign in') }
        end
        describe 'submitting to the update action' do
          before { put user_path(user) }
          specify { response.should redirect_to(signin_path) }
        end
        describe 'visiting the users index' do
          before { visit users_path }
          it { should have_title('Sign in') }
        end
      end
      describe 'when attempting to visit a protected page' do
        before do
          visit edit_user_path(user)
          sign_in user
        end
        describe 'after signing in' do
          it 'should render the desired protected page' do
            page.should have_title('Edit profile')
          end
          describe 'when signing in again' do
            before { sign_in user }
            it 'should render the default (profile) page' do
              page.should have_title(user.name)
            end
          end
        end
      end
    end
    describe 'as signed-in user' do
      let(:user) { FactoryGirl.create :user }
      before() { sign_in user }
      describe 'visiting to access Users#new page' do
        before { visit signup_path }
        it { should_not have_selector('h1', text: 'Sign up') }
      end
      describe 'submitting a POST request to the Users#create action' do
        before { post users_path }
        specify { response.should redirect_to(root_path) }
      end
    end
    describe 'as wrong user' do
      let(:user) { FactoryGirl.create :user }
      let(:wrong_user) { FactoryGirl.create :user, email: 'not_fred@example.com' }
      before { sign_in user }
      describe 'visiting Users#edit page' do
        before { visit edit_user_path(wrong_user) }
        it { should_not have_title('Edit profile') }
      end
      describe 'submitting a PUT request to the Users#update action' do
        before { put user_path(wrong_user) }
        specify { response.should redirect_to(root_path) }
      end
      describe 'invitations' do
        let(:project) { FactoryGirl.create(:project_with_owner) }
        let(:invitation) { TeamMembership.create(project: project, user: FactoryGirl.create(:user)) }
        describe 'submitting a PUT request to the TeamMemberships#accept_invitation' do
          before { put accept_invitation_path(id: invitation.id) }
          specify { response.should redirect_to(root_path) }
        end
        describe 'submitting a PUT request to the TeamMemberships#reject_invitation' do
          before { put reject_invitation_path(id: invitation.id) }
          specify { response.should redirect_to(root_path) }
        end
      end
    end
    describe 'as non-admin user' do
      let(:user) { FactoryGirl.create(:user) }
      let(:non_admin) { FactoryGirl.create(:user) }
      before { sign_in non_admin }
      describe 'submitting a DELETE request to the Users#destroy action' do
        before { delete user_path(user) }
        specify { response.should redirect_to(root_path) }
      end
    end
    describe 'as admin user' do
      let(:admin) { FactoryGirl.create(:admin) }
      before { sign_in admin }
      it 'should not be able to delete himself' do
        expect { delete user_path(admin) }.not_to change(User, :count)
      end
      describe 'trying to remove himself via a DELETE request' do
        before { delete user_path(admin) }
        specify { response.should redirect_to(root_path) }
      end
    end
  end
end
