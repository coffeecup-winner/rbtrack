# == Schema Information
#
# Table name: users
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

require 'spec_helper'

describe User do
  before { @user = User.new(name: 'Fred', email: 'fred@example.com', password: 'password',
    password_confirmation: 'password') }
  subject { @user }
  it { should respond_to :name }
  it { should respond_to :email }
  it { should respond_to :password_digest }
  it { should respond_to :password }
  it { should respond_to :password_confirmation }
  it { should respond_to :remember_token }
  it { should respond_to :admin }
  it { should respond_to :authenticate }
  it { should be_valid }
  it { should_not be_admin }
  describe 'when name is not present' do
    before { @user.name = '' }
    it { should_not be_valid }
  end
  describe 'when email is not present' do
    before { @user.email = '' }
    it { should_not be_valid }
  end
  describe 'when password is blank' do
    before { @user.password = @user.password_confirmation = ' ' }
    it { should_not be_valid }
  end
  describe 'when confirmation does not match password' do
    before { @user.password_confirmation = 'drowssap' }
    it { should_not be_valid }
  end
  describe 'when password confirmation is nil' do
    before { @user.password_confirmation = nil }
    it { should_not be_valid }
  end
  describe 'when name is too long' do
    before { @user.name = 'x' * 31 }
    it { should_not be_valid }
  end
  describe 'invalid email formats' do
    it 'should be invalid' do
      addresses = %w[user@example,com user_example_com user_example.com user.name@
        user.name@com user.name@.com user.name@example.]
      addresses.each do |address|
        @user.email = address
        @user.should_not be_valid
      end
    end
  end
  describe 'valid email formats' do
    it 'should be valid' do
      addresses = %w[user@example.com user.name@example.com user.name@example.co.uk
        USER+NAME@example.com]
      addresses.each do |address|
        @user.email = address
        @user.should be_valid
      end
    end
  end
  describe 'when the email address is not unique' do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.email = @user.email.upcase
      user_with_same_email.save
    end
    it { should_not be_valid }
  end
  it 'should be saved with lowercase email' do
    @user.email = 'SHOULD.BE.LOWERCASE@EMAIL.ADDRESS'
    @user.should be_valid
    @user.save
    @user.email.should == 'should.be.lowercase@email.address'
  end
  describe 'return value of authenticate method' do
    before { @user.save }
    let(:found_user) { User.find_by_email(@user.email) }
    describe 'with valid password' do
      it { should == found_user.authenticate(@user.password) }
    end
    describe 'with invalid password' do
      let(:auth_failed_user) { found_user.authenticate('drowssap') }
      it { should_not == auth_failed_user }
      specify { auth_failed_user.should be_false }
    end
  end
  describe 'with too short password' do
    before { @user.password = @user.password_confirmation = 'a' * 5 }
    it { should_not be_valid }
  end
  describe 'remember token' do
    before { @user.save }
    its(:remember_token) { should_not be_blank }
  end
  describe 'with admin flag' do
    before { @user.toggle!(:admin) }
    it { should be_admin }
  end
end
