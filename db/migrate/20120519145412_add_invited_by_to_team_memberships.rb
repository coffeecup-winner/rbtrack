class AddInvitedByToTeamMemberships < ActiveRecord::Migration
  def change
    add_column :team_memberships, :invited_by, :int
  end
end
