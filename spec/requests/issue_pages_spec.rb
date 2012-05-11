require 'spec_helper'

describe 'Issues' do
  subject { page }
  let(:user) { FactoryGirl.create(:user) }
  describe 'New issue page' do
    let(:submit) { 'Submit new issue' }
    before do
      sign_in user
      visit new_issue_path
    end
    it { should have_title('New issue') }
    it { should have_header('New issue') }
    describe 'with invalid information' do
      it 'should not create an issue' do
        expect { click_button submit }.not_to change(Issue, :count)
      end
      describe 'error messages' do
        before { click_button submit }
        it { should have_title('New issue') }
        it { should have_content('error') }
      end
    end
    describe 'with valid information' do
      let!(:project) { FactoryGirl.create(:project, name: 'rbtrack') }
      before do
        visit new_issue_path
        select 'rbtrack', from: 'Project'
        fill_in 'Subject', with: 'a' * 8
      end
      it 'should create an issue' do
        expect { click_button submit }.to change(Issue, :count).by(1)
      end
      describe 'after saving the issue' do
        before { click_button submit }
        let(:issue) { Issue.find_by_subject('a' * 8) }
        it { should have_title(issue.subject) }
        specify { issue.project.should == project }
      end
    end
  end
  describe 'Issue page' do
    let!(:issue) { FactoryGirl.create(:issue) }
    before { visit issue_path(issue) }
    it { should have_title(issue.project.name) }
    it { should have_title(issue.subject) }
    it { should have_header("##{issue.id}") }
    it { should have_header(issue.subject) }
    it { should have_link(issue.project.name, href: project_path(issue.project)) }
    it { should have_link(issue.user.name, href: user_path(issue.user)) }
    it { should have_content(Status.to_string(issue.status)) }
    it { should have_content(issue.description) }
    describe 'as non-signed-in user' do
      before do
        sign_in FactoryGirl.create(:user)
        visit issue_path(issue)
      end
      it { should_not have_link('Edit issue') }
      it { should_not have_link('Close issue') }
      it { should_not have_link('Reopen issue') }
      it { should_not have_link('Remove issue') }
      it { should_not have_link('Fixed') }
      it { should_not have_link('By design') }
      it { should_not have_link('Won\'t fix') }
    end
    describe 'as the issue opener' do
      before do
        sign_in issue.user
        visit issue_path(issue)
      end
      it { should have_link('Edit issue', href: edit_issue_path(issue)) }
      it { should have_link('Close issue', href: issue_path(issue, close: true), method: :put) }
      it { should_not have_link('Reopen issue') }
      it { should_not have_link('Fixed') }
      it { should_not have_link('By design') }
      it { should_not have_link('Won\'t fix') }
      describe 'edit issue' do
        before { click_link 'Edit issue' }
        it { should have_title("Edit issue ##{issue.id}") }
      end
      describe 'close issue' do
        before do
          visit issue_path(issue)
          click_link 'Close issue'
        end
        it { should have_title(issue.subject) }
        it { should have_alert_success }
        specify { Issue.find_by_subject(issue.subject).status.should == Status::CLOSED }
        describe 'after closing' do
          it { should_not have_link('Edit issue') }
          it { should_not have_link('Close issue') }
          it { should have_link('Reopen issue') }
          describe 'reopen it' do
            before { click_link 'Reopen issue' }
            it { should have_title(issue.subject) }
            specify { Issue.find_by_subject(issue.subject).status.should == Status::ACTIVE }
          end
        end
      end
    end
    describe 'as a member of the project team' do
      before do
        team_member = FactoryGirl.create(:user)
        TeamMembership.create(project: issue.project, user: team_member)
        sign_in team_member
        visit issue_path(issue)
      end
      it { should have_link('Edit issue', href: edit_issue_path(issue)) }
      it { should have_link('Fixed') }
      it { should have_link('By design') }
      it { should have_link('Won\'t fix') }
      describe 'edit issue' do
        before { click_link 'Edit issue' }
        it { should have_title("Edit issue ##{issue.id}") }
      end
      describe 'set status: fixed' do
        before do
          click_link 'Fixed'
          issue.reload
        end
        it { should have_title(issue.subject) }
        specify { issue.status.should == Status::FIXED }
      end
      describe 'set status: won\'t fix' do
        before do
          click_link 'Won\'t fix'
          issue.reload
        end
        it { should have_title(issue.subject) }
        specify { issue.status.should == Status::WONT_FIX }
      end
      describe 'set status: by design' do
        before do
          click_link 'By design'
          issue.reload
        end
        it { should have_title(issue.subject) }
        specify { issue.status.should == Status::BY_DESIGN }
      end
    end
    describe 'as admin' do
      before do
        sign_in FactoryGirl.create(:admin)
        visit issue_path(issue)
      end
      it { should have_link('Remove issue', href: issue_path(issue), method: :delete) }
      it { should_not have_link('Fixed') }
      it { should_not have_link('By design') }
      it { should_not have_link('Won\'t fix') }
      describe 'remove issue' do
        it 'should remove issue' do
          expect { click_link 'Remove issue' }.to change(Issue, :count).by(-1)
        end
        describe 'after removing' do
          before { click_link 'Remove issue' }
          it { should have_alert_success }
          it { should have_title(issue.project.name) }
        end
      end
    end
  end
  describe 'Edit page' do
    let!(:issue) { FactoryGirl.create(:issue) }
    before do
      sign_in issue.user
      visit edit_issue_path(issue)
    end
    it { should have_title("Edit issue ##{issue.id}") }
    it { should have_link(issue.project.name, href: project_path(issue.project)) }
    it { should have_link(issue.user.name, href: user_path(issue.user)) }
    describe 'fill in with invalid information' do
      before do
        fill_in 'Subject', with: 'a' * 7
        click_button 'Save changes'
      end
      it { should have_alert_error }
      it { should have_title("Edit issue ##{issue.id}") }
    end
    describe 'fill in with valid information' do
      before do
        fill_in 'Subject', with: 'b' * 8
        fill_in 'Description', with: 'abc'
        click_button 'Save changes'
      end
      it { should have_alert_success }
      it { should have_title('b' * 8) }
      it { should have_content('abc') }
    end
  end
  describe 'Issues list on the project page' do
    let!(:project) { FactoryGirl.create(:project_with_owner) }
    let!(:issue) { FactoryGirl.create(:issue, project: project) }
    before do
      sign_in project.owner
      visit project_path(project)
    end
    it { should have_content(issue.id) }
    it { should have_link(issue.subject, href: issue_path(issue)) }
  end
  describe 'Issues list on the user page' do
    let!(:project) { FactoryGirl.create(:project_with_owner) }
    let!(:issue) { FactoryGirl.create(:issue, project: project, user: user) }
    before do
      sign_in user
      visit user_path(user)
    end
    it { should have_content(issue.id) }
    it { should have_link(issue.subject, href: issue_path(issue)) }
    it { should have_link(issue.project.name, href: project_path(project)) }
  end
  describe 'links from other pages' do
    before { sign_in user }
    describe 'Report new issue from project page' do
      let!(:project) { FactoryGirl.create(:project_with_owner) }
      before do
        visit project_path(project)
        click_link 'Report an issue'
      end
      it { should have_title('New issue') }
      it { should have_select('Project', selected: project.name) }
    end
    describe 'Report new issue from home page' do
      before do
        visit root_path
        click_link 'Report an issue'
      end
      it { should have_title('New issue') }
    end
    describe 'Report new issue from user page' do
      before do
        visit user_path(user)
        click_link 'Report an issue'
      end
      it { should have_title('New issue') }
    end
  end
end