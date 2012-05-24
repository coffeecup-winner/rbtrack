# == Schema Information
#
# Table name: team_memberships
#
#  project_id          :integer
#  user_id             :integer
#  owner               :boolean
#  created_at          :datetime        not null
#  updated_at          :datetime        not null
#  invited_by          :integer
#  invitation_accepted :boolean
#  id                  :integer         not null, primary key
#

require 'spec_helper'

describe TeamMembership do
  before do
    @project = FactoryGirl.create(:project)
    @user = FactoryGirl.create(:user)
    @membership = TeamMembership.new(project: @project, user: @user)
  end
  subject { @membership }

  it { should respond_to :project }
  it { should respond_to :user }
  it { should respond_to :owner }
  its(:project) { should == @project }
  its(:user) { should == @user }
  its(:owner) { should be_false }
end
