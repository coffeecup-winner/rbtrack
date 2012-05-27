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

class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :issue

  attr_accessible :issue_id, :message

  validates :user, presence: true
  validates :issue, presence: true
  validates :message, presence: true, length: { minimum: 8, maximum: 1024 }
end
