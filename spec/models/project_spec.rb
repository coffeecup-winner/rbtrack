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
  before { @project = Project.new(name: 'rbtrack') }
  subject { @project }

  it { should respond_to :name }
  it { should respond_to :owner }
end