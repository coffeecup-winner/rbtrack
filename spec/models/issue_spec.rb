# == Schema Information
#
# Table name: issues
#
#  id          :integer         not null, primary key
#  project_id  :integer
#  user_id     :integer
#  assignee_id :integer
#  subject     :string(255)
#  description :text
#  status      :integer
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#

require 'spec_helper'

describe Issue do
  before { @issue = FactoryGirl.create(:issue) }
  subject { @issue }
  it { should respond_to :project }
  it { should respond_to :user }
  it { should respond_to :assignee }
  it { should respond_to :subject }
  it { should respond_to :description }
  it { should respond_to :status }
  it { should be_valid }
  its(:status) { should == Status::ACTIVE }
  describe 'without subject' do
    before { @issue.subject = nil }
    it { should_not be_valid }
  end
  describe 'with too short subject' do
    before { @issue.subject = 'a' * 7 }
    it { should_not be_valid }
  end
describe 'with too long subject' do
    before { @issue.subject = 'a' * 81 }
    it { should_not be_valid }
  end
  describe 'without a project' do
    before { @issue.project_id = nil }
    it { should_not be_valid }
  end
  describe 'without an opener' do
    before { @issue.user_id = nil }
    it { should_not be_valid }
  end
end
