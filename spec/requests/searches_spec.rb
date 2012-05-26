require 'spec_helper'

describe SearchController do
  subject { page }
  describe 'searching projects' do
    let!(:project) { FactoryGirl.create(:project_with_owner) }
    before { search project.name }
    it { should have_link(project.name, href: project_path(project)) }
    it { should have_link(project.owner.name, href: user_path(project.owner)) }
  end
  describe 'searching issues' do
    let!(:issue) { FactoryGirl.create(:issue) }
    before { search(issue.subject) }
    it { should have_link(issue.subject, href: issue_path(issue)) }
    it { should have_link(issue.project.name, href: project_path(issue.project)) }
    describe 'by descriptions' do
      before { search(issue.description) }
      it { should have_link(issue.subject, href: issue_path(issue)) }
      it { should have_link(issue.project.name, href: project_path(issue.project)) }
    end
  end
end
