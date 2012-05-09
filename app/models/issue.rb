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

class Issue < ActiveRecord::Base
  belongs_to :project
  belongs_to :user
  belongs_to :assignee, class_name: 'User'

  attr_accessible :description, :status, :subject

  validates :subject, presence: true, length: { minimum: 8 }
  validates :project_id, presence: true
  validates :user_id, presence: true
end
