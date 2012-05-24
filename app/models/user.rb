# == Schema Information
#
# Table name: users
#
#  id              :integer         not null, primary key
#  name            :string(255)
#  email           :string(255)
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#  password_digest :string(255)
#  remember_token  :string(255)
#  admin           :boolean         default(FALSE)
#

class User < ActiveRecord::Base
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  has_many :team_memberships
  has_many :projects, through: :team_memberships
  has_many :opened_issues, class_name: 'Issue'
  has_many :assigned_issues, class_name: 'Issue', foreign_key: 'assignee_id'

  attr_accessible :email, :name, :password_digest, :password, :password_confirmation
  has_secure_password

  validates :name, presence: true, length: { maximum: 30 }
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
            uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 6 }
  validates :password_confirmation, presence: true

  before_save -> user { user.email.downcase! }
  before_save :create_remember_token

  def active_reported_issues
    opened_issues.find_all { |issue| !issue.closed? }
  end
  def closed_reported_issues
    opened_issues.find_all { |issue| issue.closed? }
  end
  def invitations
    team_memberships.find_all { |tm| !tm.invitation_accepted? }
  end

private
  def create_remember_token
    self.remember_token = SecureRandom.urlsafe_base64
  end
end
