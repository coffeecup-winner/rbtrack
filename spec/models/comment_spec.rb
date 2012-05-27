# == Schema Information
#
# Table name: comments
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  issue_id   :integer
#  message    :text
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

require 'spec_helper'

describe Comment do
  let!(:comment) { Comment.new }
  subject { comment }
  it { should respond_to(:user) }
  it { should respond_to(:issue) }
  it { should respond_to(:message) }
  describe 'accessible attributes' do
    it 'should not allow access to user' do
      expect do
        Comment.new(user: FactoryGirl.create(:user), issue: FactoryGirl.create(:issue), message: 'texttext')
      end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
  end
  describe 'validation' do
    before do
      comment.user = FactoryGirl.create(:user)
      comment.issue = FactoryGirl.create(:issue)
      comment.message = 'a' * 8
    end
    it { should be_valid }
    describe 'message is too small' do
      before { comment.message = 'a' * 7 }
      it { should_not be_valid }
    end
    describe 'message is too big' do
      before { comment.message = 'a' * 1025 }
      it { should_not be_valid }
    end
    describe 'no message' do
      before { comment.message = nil }
      it { should_not be_valid }
    end
    describe 'no user' do
      before { comment.user = nil }
      it { should_not be_valid }
    end
    describe 'no issue' do
      before { comment.issue = nil }
      it { should_not be_valid }
    end
  end
end
