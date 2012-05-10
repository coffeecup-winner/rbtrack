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
    it { should have_selector('title', text: 'New issue') }
    it { should have_selector('h1', text: 'New issue') }
    describe 'with invalid information' do
      it 'should not create an issue' do
        expect { click_button submit }.not_to change(Issue, :count)
      end
      describe 'error messages' do
        before { click_button submit }
        it { should have_selector('title', text: 'New issue') }
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
        it { should have_selector('title', text: issue.subject) }
        specify { issue.project.should == project }
      end
    end
  end
end
