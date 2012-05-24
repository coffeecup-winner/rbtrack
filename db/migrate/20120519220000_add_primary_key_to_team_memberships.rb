class AddPrimaryKeyToTeamMemberships < ActiveRecord::Migration
  def change
    add_column :team_memberships, :id, :primary_key
  end
end
