require 'spec_helper'

describe 'User pages' do
  subject { page }
  describe 'Sign up page' do
    before { visit signup_path }
    let(:submit) { 'Create account' }
    it { should have_selector('h1', text: 'Sign up') }
    it { should have_title(full_title('Sign up'))}
    describe 'with invalid information' do
      it 'should not create a user' do
        expect { click_button submit }.not_to change(User, :count)
      end
      describe 'error messages' do
        before { click_button submit }
        it { should have_title('Sign up') }
        it { should have_content('error') }
        it { should_not have_content('digest') }
      end
    end
    describe 'with valid information' do
      before do
        fill_in 'Name', with: 'Fred Brown'
        fill_in 'Email', with: 'fred@example.com'
        fill_in 'Password', with: 'password'
        fill_in 'Confirm password', with: 'password'
      end
      it 'should create a user' do
        expect { click_button submit }.to change(User, :count).by(1)
      end
      describe 'after saving the user' do
        before { click_button submit }
        let(:user) { User.find_by_email('fred@example.com') }
        it { should have_title(user.name) }
        it { should have_alert_success('Welcome') }
        it { should have_link 'Sign out' }
      end
    end
  end
  describe 'Profile page' do
    let(:user) { FactoryGirl.create(:user) }
    before do
      sign_in user
      visit user_path(user)
    end
    it { should have_selector('h1', text: user.name) }
    it { should have_title(user.name) }
    it { should have_link('Create new project', href: new_project_path) }
    it { should have_link('Report an issue', href: new_issue_path) }
    describe 'as other user' do
      before do
        sign_in FactoryGirl.create(:user)
        visit user_path(user)
      end
      it { should_not have_link('Create new project') }
      it { should_not have_link('Report an issue') }
    end
    describe 'projects' do
      it { should have_content('Projects (0)') }
      it { should have_link('Create new project', href: new_project_path) }
      describe 'with one project' do
        let!(:project) { FactoryGirl.create(:project) }
        before do
          membership = TeamMembership.new(project: project, user: user, owner: true)
          membership.invitation_accepted = true
          membership.save!
          visit user_path(user)
        end
        it { should have_content('Projects (1)') }
        it { should have_link(project.name, href: project_path(project)) }
        it { should have_link('Delete', href: project_path(project), method: :delete) }
        describe 'removing a project' do
          before do
            click_link 'Delete'
          end
          it { should have_content('Projects (0)') }
          it { should_not have_link(project.name) }
          specify { Project.find_by_id(project.id).should be_nil }
          specify { TeamMembership.find_all_by_project_id(project.id).count.should == 0 }
        end
      end
      describe 'invitations' do
        let!(:project) { FactoryGirl.create(:project_with_owner) }
        let!(:invitation) { TeamMembership.create(project: project, user: user) }
        before do
          sign_in user
          visit user_path(user)
        end
        it { should have_link(project.name, href: project_path(project)) }
        it { should have_link 'Accept', href: accept_invitation_path(id: invitation.id), method: :put }
        it { should have_link 'Reject', href: reject_invitation_path(id: invitation.id), method: :put }
        specify { user.projects.should_not include(project) }
        describe 'accepting' do
          before { click_link 'Accept' }
          it { should have_alert_success }
          it { should have_link(project.name, href: project_path(project)) }
          it { should_not have_link 'Accept' }
          it { should_not have_link 'Reject' }
          specify { user.projects.should include(project) }
        end
        describe 'rejecting' do
          before { click_link 'Reject' }
          it { should have_alert }
          it { should_not have_link(project.name, href: project_path(project)) }
          it { should_not have_link 'Accept' }
          it { should_not have_link 'Reject' }
          specify { user.projects.should_not include(project) }
          specify { TeamMembership.find_by_user_id(user.id).should be_nil }
        end
        describe 'as other user' do
          before do
            sign_in FactoryGirl.create(:user)
            visit user_path(user)
          end
          it { should_not have_link(project.name, href: project_path(project)) }
          it { should_not have_link 'Accept', href: accept_invitation_path(id: invitation.id), method: :put }
          it { should_not have_link 'Reject', href: reject_invitation_path(id: invitation.id), method: :put }
        end
      end
    end
  end
  describe 'Edit' do
    let(:user) { FactoryGirl.create(:user) }
    before {
      sign_in user
      visit edit_user_path(user)
    }
    describe 'page' do
      it { should have_selector('h1', text: 'Update your profile') }
      it { should have_title('Edit profile') }
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
        fill_in 'Confirm password', with: user.password
        click_button 'Save changes'
      end

      it { should have_title(new_name) }
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
    let(:user) { FactoryGirl.create(:user) }
    before do
      sign_in FactoryGirl.create(:user)
      visit users_path
    end
    it { should have_title('All users') }
    describe 'pagination' do
      before(:all) { 50.times { FactoryGirl.create(:user) } }
      after(:all) { User.delete_all }
      let(:first_page) { User.paginate(page: 1) }
      let(:second_page) { User.paginate(page: 2) }
      it { should have_link 'Next' }
      its(:html) { should match('>2</a>') }
      it 'should list the first page of users' do
        first_page.each do |user|
          page.should have_selector('li', text: user.name)
        end
      end
      it 'should not list the second page of users' do
        second_page.each do |user|
          page.should_not have_selector('li', text: user.name)
        end
      end
      describe 'showing the second page' do
        before { visit users_path(page: 2) }
        it 'should list the second page of users' do
          second_page.each do |user|
            page.should have_selector('li', text: user.name)
          end
        end
      end
    end
    describe 'delete links' do
      it { should_not have_link('delete') }
      describe 'as admin' do
        let(:admin) { FactoryGirl.create(:admin) }
        before do
          sign_in admin
          visit users_path
        end
        it { should have_link('delete', href: user_path(User.first)) }
        it 'should be able to delete another user' do
          expect { click_link('delete').to change(User, :count).by(-1) }
        end
        it { should_not have_link('delete', href: user_path(admin)) }
      end
    end
  end
end
