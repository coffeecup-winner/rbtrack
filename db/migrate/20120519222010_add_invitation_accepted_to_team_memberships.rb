class AddInvitationAcceptedToTeamMemberships < ActiveRecord::Migration
  def change
    add_column :team_memberships, :invitation_accepted, :boolean
  end
end
