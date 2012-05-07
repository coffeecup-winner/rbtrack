# == Schema Information
#
# Table name: projects
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class Project < ActiveRecord::Base
  has_many :team_memberships
  has_many :users, through: :team_memberships

  attr_accessible :name

  def owner
    team_memberships.find_by_owner(true).user
  end
end