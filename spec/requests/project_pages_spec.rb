require 'spec_helper'

describe 'Projects' do
  subject { page }
  describe 'New project page' do
    let(:submit) { 'Create project' }
    describe 'when user is logged in' do
      let(:user) { FactoryGirl.create(:user) }
      before do
        sign_in user
        visit new_project_path
      end
      it { should have_selector('title', text: 'New project') }
      it { should have_selector('h1', text: 'New project') }
      describe 'with invalid information' do
        it 'should not create a project' do
          expect { click_button submit }.not_to change(Project, :count)
        end
        describe 'error messages' do
          before { click_button submit }
          it { should have_selector('title', text: 'New project') }
          it { should have_content('error') }
        end
      end
      describe 'with valid information' do
        before do
          fill_in 'Name', with: 'rbtrack'
        end
        it 'should create a project' do
          expect { click_button submit }.to change(Project, :count).by(1)
        end
        describe 'after saving the project' do
          before { click_button submit }
          let(:project) { Project.find_by_name('rbtrack') }
          it { should have_selector('title', text: project.name) }
          it { should have_alert_success(project.name) }
          specify { project.owner.should == user }
        end
      end
    end
  end
  describe 'Project page' do
    let(:project_name) { 'rbtrack' }
    before do
      create_project(project_name, FactoryGirl.create(:user))
      visit project_path(project)
    end
    let(:project) { Project.first }
    it { should have_selector('title', text: project.name) }
    it { should have_selector('h1', text: project.name) }
    it { should have_selector('li.owner', text: project.owner.name) }
    it { should have_link(project.owner.name, href: user_path(project.owner)) }
    describe 'with more than one developer' do
      pending 'TODO: implement'
    end
  end
end
