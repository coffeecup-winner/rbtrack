require 'spec_helper'

describe ApplicationHelper do
  describe 'full_title' do
    it 'Should include page title' do
      full_title('Title').should == ApplicationHelper::APPNAME + ' | Title'
    end
    it 'Should not include | on the main page' do
      full_title('').should == ApplicationHelper::APPNAME
    end
    it 'APPNAME should be rbTrack' do
      ApplicationHelper::APPNAME.should == 'rbTrack'
    end
  end
end