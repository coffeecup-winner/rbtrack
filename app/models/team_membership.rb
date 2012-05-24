# == Schema Information
#
# Table name: team_memberships
#
#  project_id          :integer
#  user_id             :integer
#  owner               :boolean
#  created_at          :datetime        not null
#  updated_at          :datetime        not null
#  invited_by          :integer
#  invitation_accepted :boolean
#  id                  :integer         not null, primary key
#

class TeamMembership < ActiveRecord::Base
  belongs_to :project
  belongs_to :user

  attr_accessible :owner, :project, :user
end
