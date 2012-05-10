require 'spec_helper'

describe 'Projects' do
  subject { page }
  let(:user) { FactoryGirl.create(:user) }
  describe 'New project page' do
    let(:submit) { 'Create project' }
    describe 'when user is logged in' do
      before do
        sign_in user
        visit new_project_path
      end
      it { should have_title('New project') }
      it { should have_selector('h1', text: 'New project') }
      describe 'with invalid information' do
        it 'should not create a project' do
          expect { click_button submit }.not_to change(Project, :count)
        end
        describe 'error messages' do
          before { click_button submit }
          it { should have_title('New project') }
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
          it { should have_title(project.name) }
          it { should have_alert_success(project.name) }
          specify { project.owner.should == user }
        end
      end
    end
  end
  describe 'Project page' do
    let(:project_name) { 'rbtrack' }
    before do
      create_project(project_name, user)
      visit project_path(project)
    end
    let(:project) { Project.first }
    it { should have_title(project.name) }
    it { should have_selector('h1', text: project.name) }
    it { should have_selector('li.owner', text: project.owner.name) }
    it { should have_link(project.owner.name, href: user_path(project.owner)) }
    describe 'with more than one developer' do
      pending 'TODO: implement'
    end
  end
  describe 'Index page' do
    before do
      sign_in user
      visit projects_path
    end
    it { should have_title('All projects') }
    describe 'pagination' do
      before(:all) { 50.times { FactoryGirl.create(:project_with_owner) } }
      after(:all) { Project.delete_all }
      let(:first_page) { Project.paginate(page: 1) }
      let(:second_page) { Project.paginate(page: 2) }
      it { should have_link 'Next' }
      its(:html) { should match('>2</a>') }
      it 'should list the first page of projects' do
        first_page.each do |project|
          page.should have_link(project.name, href: project_path(project))
          page.should have_link(project.owner.name, href: user_path(project.owner))
        end
      end
      it 'should not list the second page of projects' do
        second_page.each do |project|
          page.should_not have_selector('li', text: project.name)
        end
      end
      describe 'showing the second page' do
        before { visit projects_path(page: 2) }
        it 'should list the second page of projects' do
          second_page.each do |project|
            page.should have_link(project.name, href: project_path(project))
            page.should have_link(project.owner.name, href: user_path(project.owner))
          end
        end
      end
    end
  end
end
