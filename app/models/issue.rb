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

class Status
  ACTIVE = 0
  TO_BE_FIXED = 1
  CLOSED = 2
  FIXED = 3
  DUPLICATE = 4
  WONT_FIX = 5
  def self.to_string(status)
    case status
      when ACTIVE then 'Active'
      when TO_BE_FIXED then 'To be fixed'
      when CLOSED then 'Closed'
      when FIXED then 'Fixed'
      when DUPLICATE then 'Duplicate'
      when WONT_FIX then 'Won''t fix'
      else raise ArgumentError
    end
  end
end

class Issue < ActiveRecord::Base
  belongs_to :project
  belongs_to :user
  belongs_to :assignee, class_name: 'User'

  attr_accessible :description, :status, :subject, :project_id

  validates :subject, presence: true, length: { minimum: 8, maximum: 80 }
  validates :project_id, presence: true
  validates :user_id, presence: true

  before_create -> issue { issue.status = Status::ACTIVE }

  def closed?
    status != Status::ACTIVE && status != Status::TO_BE_FIXED
  end
end
