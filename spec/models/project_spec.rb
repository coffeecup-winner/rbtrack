# == Schema Information
#
# Table name: projects
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

require 'spec_helper'

describe Project do
  before { @project = FactoryGirl.create(:project) }
  subject { @project }

  it { should respond_to :name }
  it { should respond_to :owner }
  it { should be_valid }
  describe 'when name is not present' do
    before { @project.name = '' }
    it { should_not be_valid }
  end
  describe 'when name is too long' do
    before { @project.name = 'a' * 51 }
  end
  describe 'when name already exists' do
    let(:project_with_same_name) { @project.dup }
    before { project_with_same_name.name = @project.name.upcase }
    specify { project_with_same_name.should_not be_valid }
  end
end