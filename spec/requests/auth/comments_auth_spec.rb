require 'spec_helper'

describe 'Comments authorization' do
  subject { page }
  let(:user) { FactoryGirl.create :user }
  describe 'as non-signed-in user' do
    describe 'submitting to the Comments#create action' do
      before { post comments_path }
      specify { response.should redirect_to(signin_path) }
    end
  end
end
